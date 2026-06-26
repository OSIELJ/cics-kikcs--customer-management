//DEFCLI   JOB CLASS=A,MSGCLASS=H,MSGLEVEL=(1,1)
//*
//STEP0   EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DELETE HERC01.KICKS.CLIENTES CLUSTER PURGE
  SET LASTCC = 0
  SET MAXCC  = 0
  DEFINE CLUSTER                            -
    (NAME(HERC01.KICKS.CLIENTES)            -
     INDEXED                                -
     KEYS(6 0)                              -
     RECORDSIZE(71 80)                      -
     VOLUMES(TSO002)                        -
     UNIQUE                                 -
     TRACKS(2 1)                            -
     FREESPACE(0 0))                        -
  DATA                                      -
    (NAME(HERC01.KICKS.CLIENTES.DATA))      -
  INDEX                                     -
    (NAME(HERC01.KICKS.CLIENTES.INDEX))
/*
//STEP2   EXEC PGM=IDCAMS,COND=(8,LT,STEP0)
//SYSPRINT DD SYSOUT=*
//CLIENTES DD DSN=HERC01.KICKS.CLIENTES,DISP=SHR
//INDATA   DD *
000001MARIA SILVA                   11999887766    SAO PAULO           
000002JOAO SOUZA                    21988776655    RIO DE JANEIRO      
000003ANA OLIVEIRA                  31977665544    BELO HORIZONTE      
//SYSIN    DD *
  REPRO INFILE(INDATA) OUTFILE(CLIENTES)
/*
