MODULE PickPlace
    CONST num nZOffset:=50;
    CONST num nGripperPickTime:=0.7;
    CONST num nGripperPlaceTime:=0.2;
    CONST num nColumnCount:=7;
    CONST num nRowCount:=4;
    CONST num nLevelCount:=1;
    CONST num nColumnSpacing:=100;
    CONST num nRowSpacing:=60;
    CONST num nLevelSpacing:=80;
    VAR errnum ERR_INDEX:=-1;
    CONST speeddata vPickPlace:=v1000;
    CONST zonedata zRefZone:=z20;

    TASK PERS tooldata myTool:=[TRUE,[[0,0,70],[1,0,0,0]],[1,[0,0,1],[1,0,0,0],0,0,0]];
    TASK PERS wobjdata myWobj:=[FALSE,TRUE,"",[[616.792188266,-66.999,77.719439522],[0.99515777,0.00445988,-0.054214569,-0.081865151]],[[0,0,0],[1,0,0,0]]];
    TASK PERS loaddata loadPart:=[0.2,[0,0,50],[1,0,0,0],0,0,0];

    ! Point 00 (Matrix Origin)
    CONST robtarget pMatrixOrigin:=[[47.449599049,30.002484299,97.931915057],[0.000000001,-0.081986553,0.996633436,-0.000000003],[-1,-1,-1,0],[9E+09,9E+09,9E+09,9E+09,9E+09,9E+09]];

    !   y
    !   ^
    !   |  +----+----+----+----+----+----+----+
    !   |  | 21 | 22 | 23 | 24 | 25 | 26 | 27 |
    !   |  +----+----+----+----+----+----+----+
    !   |  | 14 | 15 | 16 | 17 | 18 | 19 | 20 |
    !   |  +----+----+----+----+----+----+----+
    !   |  | 07 | 08 | 09 | 10 | 11 | 12 | 13 |
    !   |  +----+----+----+----+----+----+----+
    !   |  | 00 | 01 | 02 | 03 | 04 | 05 | 06 |
    !   |  +----+----+----+----+----+----+----+
    !   |
    !   +-----------------------------------> x
    !   z
    !
    PROC main()
        ! Example usage
        SetDO DO_Gripper, 0;
        PerformMatrixOperation 0,\pick;
        PerformMatrixOperation 20,\place;
        PerformMatrixOperation 20,\pick;
        PerformMatrixOperation 9,\place;
        PerformMatrixOperation 9,\pick;
        PerformMatrixOperation 4,\place;
        PerformMatrixOperation 4,\pick;
        PerformMatrixOperation 0,\place;
    ENDPROC

    PROC ControlGripper(\switch pick|switch place)
        IF Present(pick) THEN
            SetDO DO_Gripper, 1;
            GripLoad loadPart;
            WaitTime nGripperPickTime;
        ELSE
            SetDO DO_Gripper, 0;
            GripLoad load0;
            WaitTime nGripperPlaceTime;
        ENDIF
    ENDPROC

    PROC PickWithZOffset(robtarget pPick)
        VAR zonedata zonePick;
        zonePick := zRefZone;
        zonePick.pzone_tcp := nZOffset/4;
        MoveJ Offs(pPick,0,0,nZOffset),vPickPlace,zonePick,myTool\WObj:=myWobj;
        MoveL pPick,vPickPlace,fine,myTool\WObj:=myWobj;
        ControlGripper\pick;
        MoveL Offs(pPick,0,0,nZOffset),vPickPlace,zonePick,myTool\WObj:=myWobj;
    ENDPROC

    PROC PlaceWithZOffset(robtarget pPlace)
        VAR zonedata zonePlace;
        zonePlace := zRefZone;
        zonePlace.pzone_tcp := nZOffset/4;
        MoveJ Offs(pPlace,0,0,nZOffset),vPickPlace,zonePlace,myTool\WObj:=myWobj;
        MoveL pPlace,vPickPlace,fine,myTool\WObj:=myWobj;
        ControlGripper\place;
        MoveL Offs(pPlace,0,0,nZOffset),vPickPlace,zonePlace,myTool\WObj:=myWobj;
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
    
    PROC syncRS()
        MoveL pMatrixOrigin,vPickPlace,fine,myTool\WObj:=myWobj;
    ENDPROC
ENDMODULE