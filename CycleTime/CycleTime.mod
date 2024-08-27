MODULE CycleTime
    VAR clock cCycleTime;
    VAR num nCycleDone:=0;
    VAR num nSecondesPerCycle;
    VAR num nCyclePerHour;
    VAR num nCyclePerMinute;
    VAR num nTotalCycleTime:=0;
    VAR num nAverageSecondsPerCycle;
    VAR num nMinCycleTime:=9999999;
    VAR num nMaxCycleTime:=0;
    VAR num nLastCycleTime;

    PROC main()
        StartSimulation;
        FOR i FROM 1 TO 10 DO
            SimulateCycle;
            CycleComplete;
        ENDFOR
        PrintStatistics;
    ENDPROC

    PROC StartSimulation()
        TPErase;
        ClkStop cCycleTime;
        ClkReset cCycleTime;
        ClkStart cCycleTime;
    ENDPROC

    PROC CycleComplete()
        nLastCycleTime:=ClkRead(cCycleTime);
        ClkReset cCycleTime;
        ClkStart cCycleTime;
        Incr nCycleDone;
        nTotalCycleTime:=nTotalCycleTime+nLastCycleTime;
        UpdateStatistics;
    ENDPROC

    PROC PrintStatistics()
        TPWrite "Cycle Time Statistics:";
        TPWrite " Total Cycles Time: "\num:=nTotalCycleTime;
        TPWrite " Total Cycles: "\num:=nCycleDone;
        TPWrite " Average Cycle Time: "\num:=nAverageSecondsPerCycle;
        TPWrite " Min Cycle Time: "\num:=nMinCycleTime;
        TPWrite " Max Cycle Time: "\num:=nMaxCycleTime;
        TPWrite " Cycles per Hour: "\num:=nCyclePerHour;
        TPWrite " Cycles per Minute: "\num:=nCyclePerMinute;
    ENDPROC

    PROC SimulateCycle()
        WaitTime 1+((Rand()/32767)*0.5);
    ENDPROC

    PROC UpdateStatistics()
        IF (nLastCycleTime<nMinCycleTime) THEN
            nMinCycleTime:=nLastCycleTime;
        ENDIF
        IF (nLastCycleTime>nMaxCycleTime) THEN
            nMaxCycleTime:=nLastCycleTime;
        ENDIF
        nSecondesPerCycle:=nTotalCycleTime/nCycleDone;
        nCyclePerHour:=3600/nSecondesPerCycle;
        nCyclePerMinute:=60/nSecondesPerCycle;
        nAverageSecondsPerCycle:=nTotalCycleTime/nCycleDone;
    ENDPROC
ENDMODULE