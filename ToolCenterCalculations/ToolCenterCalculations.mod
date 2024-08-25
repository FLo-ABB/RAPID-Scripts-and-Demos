MODULE ToolCenterCalculations
    ! ------------------------------------------------------------------------------
    ! This module defines a Tool Center calibration process using sphere fitting. If the
    ! number of points taught is 4, the built-in MToolTCPCalib method is used.
    ! The "main" procedure is an example and should be removed to avoid multiple main
    ! definitions. The robtargets are defined using tool0, named pToolCenterTaughtX where
    ! X ranges from 1 to the number of points taught. The module includes procedures
    ! for initializing, calculating the Tool Center Point (TCP), and displaying results.
    ! ------------------------------------------------------------------------------

    ! nNumberPoints defines the number of points used for ToolCenter calibration
    CONST num nNumberPoints:=5; ! EDIT HERE
    VAR robtarget robtargetsArray{nNumberPoints};
    ! Robtargets defined using tool0 pointing at the world fixed tip in wobj0
    ! Names has to be pToolCenterTaughtX where X go from 1 to the number of points taught
    CONST robtarget pToolCenterTaught1:=[[687.278,-21.441,952.46],[0.4999980098,0,0.8660265528,0],[-1,0,-1,0],[9E9,9E9,9E9,9E9,9E9,9E9]];
    CONST robtarget pToolCenterTaught2:=[[687.1,74.346,928.655],[0.4845914897,-0.1231803787,0.8393325802,-0.2133506559],[0,-1,0,0],[9E9,9E9,9E9,9E9,9E9,9E9]];
    CONST robtarget pToolCenterTaught3:=[[817.3,-126.79,1056.294],[0.242960218,0.1903601708,0.9324608367,0.1877501685],[-1,0,0,0],[9E9,9E9,9E9,9E9,9E9,9E9]];
    CONST robtarget pToolCenterTaught4:=[[1148.2,-123.85,1066.227],[-0.2265697823,0.2564897536,0.9365791002,0.0754899275],[-1,0,0,0],[9E9,9E9,9E9,9E9,9E9,9E9]];
    CONST robtarget pToolCenterTaught5:=[[1131,188.9,1016.085],[-0.2129896855,-0.1088798392,0.9284486291,-0.2841895804],[0,-1,-1,0],[9E9,9E9,9E9,9E9,9E9,9E9]];
    ! CONST robtarget pToolCenterTaughtX:=...; ! EDIT HERE

    PERS pos posArraySphereTool0{nNumberPoints};

    VAR pos posCenterSphereWobj0;
    VAR num nRadiusSphereWobj0;

    VAR pos posToolCenter;
    VAR num nMaxError;
    VAR num nMeanError;
    
    ! Result:
    TASK PERS tooldata toolToDeterminate:=[TRUE,[[20.1787,0.743817,363.376],[0.946578,0.191449,0.0562058,0.253336]],[1,[0,0,1],[1,0,0,0],0,0,0]];

    PROC main()
        init;
        calcToolCenter;
        displayResults;
    ERROR
        ExitCycle;
    ENDPROC

    PROC calcError()
        VAR num sum:=0;
        VAR num dist;
        nMeanError:=0;
        nMaxError:=0;

        FOR i FROM 1 TO nNumberPoints DO
            dist:=Distance(posToolCenter,posArraySphereTool0{i});
            sum:=sum+dist;
            nMaxError:=Max(nMaxError,dist);
        ENDFOR
        nMeanError:=sum/nNumberPoints;
    ENDPROC

    PROC calcToolCenter()
        ! MToolTCPCalib is a built-in routine if the number of points taught is 4.
        VAR num max_err;
        VAR num mean_err;
        IF nNumberPoints=4 THEN
            MToolTCPCalib CalcJointT(pToolCenterTaught1,tool0),CalcJointT(pToolCenterTaught2,tool0),CalcJointT(pToolCenterTaught3,tool0),CalcJointT(pToolCenterTaught4,tool0),toolToDeterminate,max_err,mean_err;
            posToolCenter:=toolToDeterminate.tframe.trans;
            nMeanError:=mean_err;
            nMaxError:=max_err;
        ELSE
            ! Calculates the Tool Center Point (ToolCenter) based on sphere fitting
            findSphereInWobj0;
            findSphereInTool0;
            toolToDeterminate.tframe.trans:=posToolCenter;
        ENDIF
    ERROR
        RAISE ;
    ENDPROC

    PROC displayResults()
        TPWrite "ToolCenter Calibration Complete";
        TPWrite "ToolCenter Position: "\pos:=posToolCenter;
        TPWrite "  Max Error: "\num:=nMaxError;
        TPWrite "  Mean Error: "\num:=nMeanError;
    ENDPROC

    PROC findSphereInTool0()
        ! Finds the center and radius of a sphere in the tool frame
        VAR pos posCenterTemp;
        VAR num nRadiusTemp;
        ! Calculate the position of the center of the sphere in the tool frame for every point taught
        FOR i FROM 1 TO nNumberPoints DO
            posArraySphereTool0{i}:=PoseVect(PoseInv([robtargetsArray{i}.trans,robtargetsArray{i}.rot]),posCenterSphereWobj0);
        ENDFOR
        ! Find the sphere created by the points in the tool frame
        FitSphere posArraySphereTool0,posCenterTemp,nRadiusTemp;
        posToolCenter:=posCenterTemp;
        calcError;
    ENDPROC

    PROC findSphereInWobj0()
        ! Finds the center and radius of a sphere in the work object frame
        VAR pos posCenterTemp;
        VAR num nRadiusTemp;
        VAR pos posArraySphereWobj0{nNumberPoints};
        FOR i FROM 1 TO nNumberPoints DO
            posArraySphereWobj0{i}:=robtargetsArray{i}.trans;
        ENDFOR
        FitSphere posArraySphereWobj0,posCenterTemp,nRadiusTemp;
        posCenterSphereWobj0:=posCenterTemp;
        nRadiusSphereWobj0:=nRadiusTemp;
    ERROR
        IF ERRNO=ERR_FIT_TOO_FEW_POINTS THEN
            TPWrite "Error: Too few points to determine the sphere. At least 3 points are required.";
        ELSEIF ERRNO=ERR_FIT_TOO_MANY_POINTS THEN
            TPWrite "Error: Too many points to determine the sphere. Maximum allowed is 100.";
        ELSEIF ERRNO=ERR_FIT_POINTS_IN_LINE THEN
            TPWrite "Error: Incorrect points given. The points must not be in a straight line.";
        ELSE
            TPWrite "An unexpected error occurred in findSphereInWobj0, ERRNO:"\num:=ERRNO;
        ENDIF
        RAISE ;
    ENDPROC

    PROC init()
        TPErase;
        initializeRobTargetsArray;
    ENDPROC

    PROC initializeRobTargetsArray()
        ! Fill the robtargets array with the taught points
        FOR i FROM 1 TO nNumberPoints DO
            GetDataVal "pToolCenterTaught"+ValToStr(i),robtargetsArray{i};
        ENDFOR
    ERROR
        TPWrite "Impossible to initialize the robtargets array:";
        TPWrite "- check the number of points taught,";
        TPWrite "- the consistency with the variable nNumberPoints,";
        TPWrite "- the naming convention pToolCenterTaughtX";
        RAISE ;
    ENDPROC

    PROC syncRS()
        MoveJ pToolCenterTaught1,vmax,fine,tool0;
        MoveJ pToolCenterTaught2,vmax,fine,tool0;
        MoveJ pToolCenterTaught3,vmax,fine,tool0;
        MoveJ pToolCenterTaught4,vmax,fine,tool0;
        MoveJ pToolCenterTaught5,vmax,fine,tool0;
    ENDPROC
ENDMODULE