       IDENTIFICATION DIVISION.
       PROGRAM-ID. CADCLI.
       AUTHOR. OSIEL.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WKR-CODIGO                 PIC X(06).
       01  WKR-NOME                   PIC X(30).
       01  WKR-FONE                   PIC X(15).
       01  WKR-CIDADE                 PIC X(20).
       01  WKR-MENSAGEM               PIC X(40).
       01  WKR-RESP                   PIC S9(4) COMP.
       01  WKR-TAM-REG                PIC S9(4) COMP VALUE +71.
       01  WKR-PF3                    PIC X VALUE X'F3'.
       01  WKR-PF5                    PIC X VALUE X'F5'.
       01  WKR-PF6                    PIC X VALUE X'F6'.
       01  WKR-REGISTRO.
           05  CLI-CODIGO             PIC X(06).
           05  CLI-NOME               PIC X(30).
           05  CLI-FONE               PIC X(15).
           05  CLI-CIDADE             PIC X(20).
       COPY MAPSCA.
       PROCEDURE DIVISION.
       INICIAR.
           MOVE SPACES TO WKR-CODIGO.
           MOVE SPACES TO WKR-NOME.
           MOVE SPACES TO WKR-FONE.
           MOVE SPACES TO WKR-CIDADE.
           MOVE 'INFORME O CODIGO E TECLE PF5.' TO WKR-MENSAGEM.
           GO TO MOSTRAR-TELA.
       RECEBER-TELA.
           EXEC KICKS
               RECEIVE MAP('TELACA')
                       MAPSET('MAPSCA')
                       INTO(TELACAI)
                       NOHANDLE
           END-EXEC.
           IF EIBAID = WKR-PF3
              GO TO SAIR.
           IF EIBAID = WKR-PF5
              GO TO CONSULTAR.
           IF EIBAID = WKR-PF6
              GO TO SALVAR.
           MOVE 'USE PF3, PF5 OU PF6.' TO WKR-MENSAGEM.
           GO TO MOSTRAR-TELA.
       CONSULTAR.
           MOVE CODIGOI TO WKR-CODIGO.
           IF WKR-CODIGO = SPACES
              GO TO SEM-CODIGO.
           MOVE ZERO TO WKR-RESP.
           EXEC KICKS
               READ DATASET('CLIENTES')
                    INTO(WKR-REGISTRO)
                    RIDFLD(WKR-CODIGO)
                    RESP(WKR-RESP)
                    NOHANDLE
           END-EXEC.
           IF WKR-RESP = ZERO
              GO TO CLIENTE-ACHADO.
           IF WKR-RESP = 13
              GO TO CLIENTE-NAO-ACHADO.
           MOVE 'ERRO NA CONSULTA.' TO WKR-MENSAGEM.
           GO TO MOSTRAR-TELA.
       SALVAR.
           MOVE CODIGOI TO WKR-CODIGO.
           MOVE FONEI TO WKR-FONE.
           MOVE CIDADEI TO WKR-CIDADE.
           IF WKR-CODIGO = SPACES
              GO TO SEM-CODIGO.
           MOVE ZERO TO WKR-RESP.
           EXEC KICKS
               READ DATASET('CLIENTES')
                    INTO(WKR-REGISTRO)
                    RIDFLD(WKR-CODIGO)
                    UPDATE
                    RESP(WKR-RESP)
                    NOHANDLE
           END-EXEC.
           IF WKR-RESP = ZERO
              GO TO ATUALIZAR.
           IF WKR-RESP = 13
              GO TO CLIENTE-NAO-ACHADO.
           MOVE 'ERRO NA LEITURA.' TO WKR-MENSAGEM.
           GO TO MOSTRAR-TELA.
       SEM-CODIGO.
           MOVE 'INFORME O CODIGO.' TO WKR-MENSAGEM.
           GO TO MOSTRAR-TELA.
       CLIENTE-ACHADO.
           MOVE CLI-NOME    TO WKR-NOME.
           MOVE CLI-FONE    TO WKR-FONE.
           MOVE CLI-CIDADE  TO WKR-CIDADE.
           MOVE 'CLIENTE ENCONTRADO.' TO WKR-MENSAGEM.
           GO TO MOSTRAR-TELA.
       CLIENTE-NAO-ACHADO.
           MOVE SPACES TO WKR-NOME.
           MOVE SPACES TO WKR-FONE.
           MOVE SPACES TO WKR-CIDADE.
           MOVE 'CLIENTE NAO ENCONTRADO.' TO WKR-MENSAGEM.
           GO TO MOSTRAR-TELA.
       ATUALIZAR.
           MOVE WKR-FONE    TO CLI-FONE.
           MOVE WKR-CIDADE  TO CLI-CIDADE.
           MOVE ZERO TO WKR-RESP.
           EXEC KICKS
               REWRITE DATASET('CLIENTES')
                       FROM(WKR-REGISTRO)
                       LENGTH(WKR-TAM-REG)
                       RESP(WKR-RESP)
                       NOHANDLE
           END-EXEC.
           IF WKR-RESP = ZERO
              GO TO ALTERACAO-OK.
           MOVE 'ERRO AO ATUALIZAR.' TO WKR-MENSAGEM.
           GO TO MOSTRAR-TELA.
       ALTERACAO-OK.
           MOVE CLI-NOME    TO WKR-NOME.
           MOVE CLI-FONE    TO WKR-FONE.
           MOVE CLI-CIDADE  TO WKR-CIDADE.
           MOVE 'ALTERACAO REALIZADA.' TO WKR-MENSAGEM.
           GO TO MOSTRAR-TELA.
       MOSTRAR-TELA.
           MOVE LOW-VALUES TO TELACAO.
           MOVE WKR-CODIGO   TO CODIGOO.
           MOVE WKR-NOME     TO NOMEO.
           MOVE WKR-FONE     TO FONEO.
           MOVE WKR-CIDADE   TO CIDADEO.
           MOVE WKR-MENSAGEM TO MSGO.
           EXEC KICKS
               SEND MAP('TELACA')
                    MAPSET('MAPSCA')
                    FROM(TELACAO)
                    ERASE
                    FREEKB
           END-EXEC.
           GO TO RECEBER-TELA.
       SAIR.
           EXEC KICKS
               RETURN
           END-EXEC.
