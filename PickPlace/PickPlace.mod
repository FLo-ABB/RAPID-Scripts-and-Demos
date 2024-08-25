MODULE PickPlace
    ! Constants
    CONST num nZOffset:=50;
    CONST num nGripperPickTime:=0.7;
    CONST num nGripperPlaceTime:=0.2;
    CONST num nColumnCount:=7;
    CONST num nRowCount:=3;
    CONST num nLevelCount:=1;
    CONST num nColumnSpacing:=10;
    CONST num nRowSpacing:=15;
    CONST num nLevelSpacing:=80;
    VAR errnum ERR_INDEX:=-1;

    ! Task persistent data
    TASK PERS tooldata myTool:=[TRUE,[[0,0,0],[1,0,0,0]],[0,[0,0,0],[1,0,0,0],0,0,0]];
    TASK PERS wobjdata myWobj:=[FALSE,TRUE,"",[[0,0,0],[1,0,0,0]],[[0,0,0],[1,0,0,0]]];

    ! Point 00 (Matrix Origin)
    CONST robtarget pMatrixOrigin:=[[0,0,0],[1,0,0,0],[0,0,0,0],[9E9,9E9,9E9,9E9,9E9,9E9]];

    ! Speed data
    CONST speeddata vPickPlace:=v100;

    !   y
    !   ^
    !   |
    !   |  +----+----+----+----+----+----+----+
    !   |  | 14 | 15 | 16 | 17 | 18 | 19 | 20 |
    !   |  +----+----+----+----+----+----+----+
    !   |  | 07 | 08 | 09 | 10 | 11 | 12 | 13 |
    !   |  +----+----+----+----+----+----+----+
    !   |  | 00 | 01 | 02 | 03 | 04 | 05 | 06 |
    !   |  +----+----+----+----+----+----+----+
    !   |
    !   +-----------------------------------> x

    PROC main()
        ! Example usage
        PerformMatrixOperation 0,\pick;
        PerformMatrixOperation 20,\place;
    ENDPROC

    PROC ControlGripper(\switch pick|switch place)
        IF Present(pick) THEN
            ! Manage Inputs/Outputs to pick
            ! SetDO DO_Gripper, 1;
            WaitTime nGripperPickTime;
        ELSE
            ! Manage Inputs/Outputs to place
            ! SetDO DO_Gripper, 0;
            WaitTime nGripperPlaceTime;
        ENDIF
    ENDPROC

    PROC PickWithZOffset(robtarget pPick)
        MoveJ Offs(pPick,0,0,nZOffset),vPickPlace,z20,myTool\WObj:=myWobj;
        MoveL pPick,vPickPlace,fine,myTool\WObj:=myWobj;
        ControlGripper\pick;
        MoveL Offs(pPick,0,0,nZOffset),vPickPlace,z20,myTool\WObj:=myWobj;
    ENDPROC

    PROC PlaceWithZOffset(robtarget pPlace)
        MoveJ Offs(pPlace,0,0,nZOffset),vPickPlace,z20,myTool\WObj:=myWobj;
        MoveL pPlace,vPickPlace,fine,myTool\WObj:=myWobj;
        ControlGripper\place;
        MoveL Offs(pPlace,0,0,nZOffset),vPickPlace,z20,myTool\WObj:=myWobj;
    ENDPROC

    PROC PerformMatrixOperation(num nPositionIndex,\switch pick|switch place)
        VAR num nColumnIndex;
        VAR num nRowIndex;
        VAR num nLevelIndex;
        VAR robtarget pTarget;
        VAR num errorid:=4800;
        VAR errstr my_title:="Bad Position index";
        VAR errstr str1:="The position index given is negative or superior to the matrix size";

        IF nPositionIndex<0 OR nPositionIndex>=nColumnCount*nRowCount*nLevelCount THEN
            BookErrNo ERR_INDEX;
            ErrRaise "ERR_INDEX",errorid,my_title,ERRSTR_TASK,str1,ERRSTR_CONTEXT,ERRSTR_EMPTY;
        ENDIF

        nColumnIndex:=nPositionIndex MOD nColumnCount;
        nRowIndex:=(nPositionIndex DIV nColumnCount) MOD nRowCount;
        nLevelIndex:=nPositionIndex DIV (nColumnCount*nRowCount);

        pTarget:=Offs(pMatrixOrigin,nColumnIndex*nColumnSpacing,nRowIndex*nRowSpacing,nLevelIndex*nLevelSpacing);

        IF Present(pick) THEN
            PickWithZOffset pTarget;
        ELSE
            PlaceWithZOffset pTarget;
        ENDIF
    ERROR
        IF ERRNO=ERR_INDEX THEN
            RETURN ;
        ENDIF
    ENDPROC

    FUNC bool IsPositionValid(num nPositionIndex)
        RETURN nPositionIndex>=0 AND nPositionIndex<nColumnCount*nRowCount*nLevelCount;
    ENDFUNC
ENDMODULE