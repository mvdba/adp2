WHENEVER SQLERROR EXIT FAILURE ROLLBACK
CONNECT &1/&2

CREATE OR REPLACE PACKAGE BODY mdb_ar_ret_load_iface_pk IS
-- $Header: MDB_AR_RET_LOAD_IFACE_PKB.pls 115.14 2006-11-27 20:47:41 -0300 marcus.ferreira svnid_4774 $
-- $Id: MDB_PKB.pls 7903 2007-01-15 22:09:21Z marcus.ferreira $   --      --      --.
-- +=================================================================+
-- |               ALEJANDRO Consultoria, Sao Paulo, Brasil          |
-- |                       All rights reserved.                      |
-- +=================================================================+
-- | FILENAME                                                        |
-- |  MDB_AR_RET_LOAD_IFACE_PKB.pls                                  |
-- |                                                                 |
-- | PURPOSE                                                         |
-- |  MDB - Carga da Interface do Retorno Bancário                   |
-- |                                                                 |
-- | DESCRIPTION                                                     |
-- |  Serão processados todos os registros do aquivo indicado no     |
-- | parâmetro identificando-se as ocorrências e seus motivos e      |
-- | armazenando na tabela MDB_AR_RET_REASON_ALL.                    |
-- |                                                                 |
-- |                                                                 |
-- | PARAMETERS                                                      |
-- |                                                                 |
-- |                                                                 |
-- | CREATED BY   Cristiano Meneguello / 18/09/2006                  |
-- |                                                                 |
-- | UPDATED BY   Cristiano Meneguello / 10/10/2006                  |
-- |   Alteração na rotina que busca os campos do arquivo dos bancos |
-- | Para buscar corretamente a data da ocorrencia e do motivo       |
-- |                                                                 |
-- | UPDATED BY   Cristiano Meneguello / 19/10/2006                  |
-- |   Alteração na linha 139, da posição 378 para posicao 319.      |
-- |              Cristiano Meneguello / 26/10/2006                  |
-- |   Alteração na linha 132. De 12 posições para 3                 |
-- |   Alteração na condição para inserir para o banco 341 e 237     |
-- | apenas quando existir REASON_CODE.                              |
-- |              Cristiano Meneguello / 03/11/2006                  |
-- |   Alteracao para insercao e busca dos codigos de motivo         |
-- |   para o banco 341. Inserir apenas quando o codigo do motivo    |
-- |   for diferente de zero                                         |
-- |              Cristiano Meneguello  / 08/11/2006                 |
-- |   Alteracao na rotina do banco Itau, quando for despesas carto- |
-- | rárias (33, 34, 35 ou 36) insere sem codigo do motivo           |
-- |                                                                 |
-- |               Roberto Carlos    / 13/11/2006                    |
-- |   Tratamento do erro : "PL/SQL: numeric or value error" na lin. |
-- |            na linha 123                                         |
-- |   Tratar motivo 0 igual a motivo nulo                           |
-- |               Cristiano Meneguello                              |
-- |   Tratar motivo 03 e ocorrencia 33 para banco itau.             |
-- |  Tratar motivo 0 e motivo Nulo.                                 |
-- +=================================================================+
--

  PROCEDURE ret_bank_load_iface_p(errbuf            OUT VARCHAR2
                                , retcode           OUT NUMBER
                                , p_bank_number     IN NUMBER
                                , p_balancing_seg   IN VARCHAR2
                                , p_location        IN VARCHAR2
                                , p_file_name       IN VARCHAR2
                                , p_set_of_books_id IN NUMBER) IS

  l_fTransfer_File   utl_file.file_type;
  l_vFile_Line       VARCHAR2(2000);


  l_line_counter     NUMBER := 0;
  l_rRet_Reason_line mdb_ar_ret_reason_all%ROWTYPE;

  l_nCount           NUMBER := 0;


  BEGIN

    BEGIN
    --> Abre o arquivo para leitura
    --
      l_fTransfer_File := utl_file.fopen(location     => p_location
                                       , filename     => p_file_name
                                       , open_mode    => 'r'
                                       , max_linesize => 32767);
      EXCEPTION
        WHEN utl_file.invalid_path THEN
             fnd_file.put_line(fnd_file.log, 'Caminho de Arquivo Invalido. Caminho: '|| p_location);
             RAISE_APPLICATION_ERROR(-20000, 'Caminho de Arquivo Invalido. Caminho: '|| p_location);
        WHEN utl_file.invalid_mode THEN
             fnd_file.put_line(fnd_file.log, 'Modo de Abertura Invalido (R).');
             RAISE_APPLICATION_ERROR(-20001, 'Modo de Abertura Invalido (R).');
        WHEN utl_file.invalid_filename THEN
             fnd_file.put_line(fnd_file.log, 'Arquivo Invalido. Nome: ' || p_file_name);
             RAISE_APPLICATION_ERROR(-20002, 'Arquivo Invalido. Nome: ' || p_file_name);
        WHEN utl_file.access_denied THEN
             fnd_file.put_line(fnd_file.log, 'Acesso de leitura ao arquivo negado.');
             RAISE_APPLICATION_ERROR(-20003, 'Acesso de leitura ao arquivo negado.');
        WHEN utl_file.invalid_operation THEN
             fnd_file.put_line(fnd_file.log, 'Operação Invalida: ' || SQLERRM);
             RAISE_APPLICATION_ERROR(-20004, 'Operação Invalida: ' || SQLERRM);
        WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR(-20005, 'Erro na Abertura do Arquivo: ' || SQLERRM);
    END;

    LOOP
      --> Pega a Proxima linha do arquivo
      --
      BEGIN
        IF utl_file.is_open(l_fTransfer_File) THEN

          utl_file.get_line(file => l_fTransfer_File
                           ,buffer => l_vFile_Line);

          l_line_counter    := l_line_counter + 1;

        END IF;

      EXCEPTION
        WHEN no_data_found THEN
          EXIT;
        WHEN utl_file.read_error THEN
          fnd_file.put_line(fnd_file.log, 'Erro na Leitura da Linha : '||l_line_counter||' : '||SQLERRM);
          RAISE_APPLICATION_ERROR(-20005, 'Erro na Leitura da Linha : '||l_line_counter||' : '||SQLERRM);
        WHEN OTHERS THEN
          fnd_file.put_line(fnd_file.log, 'Erro Generico na Leitura da Linha '||l_line_counter||': '||SQLERRM);
          RAISE_APPLICATION_ERROR(-20006, 'Erro Generico na Leitura da Linha '||l_line_counter||': '||SQLERRM);
      END;

      BEGIN

        IF NOT substr(l_vFile_Line, 1, 1) = 'O' OR substr(l_vFile_Line, 1, 1) = '9' THEN

          IF substr(l_vFile_Line, 1, 1) = '1' THEN

            IF p_bank_number = '001' THEN
              l_rRet_Reason_line.Bank_Number          := '001';
              l_rRet_Reason_line.Document_Id          := to_number(trim(substr(l_vFile_Line, 38, 25)));
              l_rRet_Reason_line.Bank_Occurrence_Code := substr(l_vFile_Line, 109, 2);
              --> Verifica se a Data da ocorrência é nula
              --
              IF substr(l_vFile_Line, 111, 6) <> '000000' THEN
                l_rRet_Reason_line.Occurrence_Date := to_date(substr(l_vFile_Line, 111, 6), 'dd/mm/yy');
              ELSE
                l_rRet_Reason_line.Occurrence_Date := NULL;
              END IF;

              l_rRet_Reason_line.Reason_Code          := substr(l_vFile_Line, 81, 2);

              IF l_rRet_Reason_line.Bank_Occurrence_Code = '96' OR
                 l_rRet_Reason_line.Bank_Occurrence_Code = '97' OR
                 l_rRet_Reason_line.Bank_Occurrence_Code = '98' THEN

                l_rRet_Reason_line.Reason_Value := to_number(substr(l_vFile_Line, 306, 13)) / 100;
              END IF;

              --> Chama a Package para inserção
              --
              mdb_ar_ret_load_iface_pk.insert_row_p (l_rRet_Reason_line);

            ELSIF p_bank_number = '237' THEN

              --> Verifica se o Codigo do Motivo é nulo
              --
              IF substr(l_vFile_Line, 319, 2) = '  ' THEN
                l_rRet_Reason_line.Reason_Code := NULL;
              ELSE
                l_rRet_Reason_line.Reason_Code := to_number(substr(l_vFile_Line, 319, 2));
              END IF;

              --> Faz o LOOP para pegar todos os codigos do Motivo
              --
              FOR l_nCount IN 1 .. 8 LOOP

                IF MOD(l_nCount, 2) = 0 THEN
                  --> Atribui ao Reason Code o codigo encontrado nos 2 caracteres atuais
                  --
                  l_rRet_Reason_line.Reason_Code := to_number(substr(l_vFile_Line, 319 + l_nCount, 2));

                  IF l_rRet_Reason_line.Bank_Occurrence_Code = '28'
                     AND l_rRet_Reason_line.Reason_Code = '08' THEN

                    l_rRet_Reason_line.Reason_Value := to_number(substr(l_vFile_Line, 189, 13)) / 100;

                  END IF;
                  --> Se existir characteres para proximo Reason_code, já insere.
                  --
                  IF l_rRet_Reason_line.Reason_Code <> 0 THEN

                    mdb_ar_ret_load_iface_pk.insert_row_p(l_rRet_Reason_line);
                  END IF;

                END IF;

                IF l_nCount = 1 THEN

                  l_rRet_Reason_line.Bank_Number          := '237';
                  l_rRet_Reason_line.Document_Id          := substr(l_vFile_Line, 38, 25);
                  l_rRet_Reason_line.Bank_Occurrence_Code := substr(l_vFile_Line, 109, 2);

                  --> Verifica se a Data do Motivo é nulo
                  --
                  IF substr(l_vFile_Line, 111, 6) <> '000000' THEN
                    l_rRet_Reason_line.Occurrence_Date      := to_date(substr(l_vFile_Line, 111, 6), 'dd/mm/yy');
                  ELSE
                    l_rRet_Reason_line.Occurrence_Date := NULL;
                  END IF;

                  IF l_rRet_Reason_line.Bank_Occurrence_Code = '28'
                    AND l_rRet_Reason_line.Reason_Code = '08' THEN

                    l_rRet_Reason_line.Reason_Value := to_number(substr(l_vFile_Line, 189, 13)) / 100;

                  END IF;

                  --> Chama a package para inserção
                  --
                  IF l_rRet_Reason_line.Reason_Code <> 0 THEN
                    mdb_ar_ret_load_iface_pk.insert_row_p(l_rRet_Reason_line);
                  END IF;

                  --> Se o primeiro codigo de motivo for nulo, insere uma linha e sai
                  --
                  IF l_rRet_Reason_line.Reason_Code IS NULL THEN
                    EXIT;
                  END IF;

                END IF;

              END LOOP;

            ELSIF p_bank_number = '341' THEN

              --> Verifica se o Codigo do Motivo é nulo
              --
              IF substr(l_vFile_Line, 378, 2) = '  ' THEN
                l_rRet_Reason_line.Reason_Code := NULL;
              ELSE
                l_rRet_Reason_line.Reason_Code := to_number(substr(l_vFile_Line, 378, 2));
              END IF;

              --> Faz o LOOP para pegar todos os codigos do Motivo
              --
              FOR l_nCount IN 1.. 6 LOOP

                IF MOD(l_nCount, 2) = 0 THEN
                  --> Atribui ao Reason Code o codigo encontrado nos 2 caracteres atuais
                  --
                  l_rRet_Reason_line.Reason_Code := to_number(substr(l_vFile_Line, 378 + l_nCount, 2));

                  IF l_rRet_Reason_line.Bank_Occurrence_Code = '57' THEN
                    --> Se não existir Reason_code para o proximo conjunto não atribui
                    --
                    IF l_rRet_Reason_line.Reason_Code <> 0 THEN
                      l_rRet_Reason_line.Reason_Code := to_number(substr(l_vFile_Line, 302, 4));
                    END IF;

                  ELSIF l_rRet_Reason_line.Bank_Occurrence_Code = '24' OR
                        l_rRet_Reason_line.Bank_Occurrence_Code = '25' THEN

                    --> Se não existir Reason_code para o proximo conjunto não atribui
                    --
                    IF l_rRet_Reason_line.Reason_Code <> 0 THEN
                      l_rRet_Reason_line.Reason_Code := to_number(substr(l_vFile_Line, 302, 4));
                    END IF;

                    --> Verifica se a Data do Motivo é nula.
                    --
                    IF substr(l_vFile_Line, 306, 6) <> '000000' THEN
                      l_rRet_Reason_line.Reason_Date := to_date(substr(l_vFile_Line, 306, 6), 'dd/mm/yy');
                    ELSE
                      l_rRet_Reason_line.Reason_Date := NULL;
                    END IF;

                    l_rRet_Reason_line.Reason_Adit := to_number(substr(l_vFile_Line, 312, 13)) / 100;

                    --> Trata o campo Reason_adit para não inserir zeros
                    --
                    IF l_rRet_Reason_line.Reason_Adit = '0' THEN
                      l_rRet_Reason_line.Reason_Adit := NULL;
                    END IF;


                  END IF;

                  IF l_rRet_Reason_line.Bank_Occurrence_Code = '33' OR
                    l_rRet_Reason_line.Bank_Occurrence_Code = '34' OR
                    l_rRet_Reason_line.Bank_Occurrence_Code = '35' OR
                    l_rRet_Reason_line.Bank_Occurrence_Code = '36' THEN

                    --l_rRet_Reason_line.Reason_Value := to_number(substr(l_vFile_Line, 176, 13), '999G999G990D99') / 100;
                    --\ Alt. 13/11/2006
                    l_rRet_Reason_line.Reason_Value := to_number(substr(l_vFile_Line, 176, 13)) / 100;
                    --> Chama a package para inserção quando ocorrer despesas cartorárias
                    --
                    mdb_ar_ret_load_iface_pk.insert_row_p(l_rRet_Reason_line);
                    l_rRet_Reason_line.Reason_Code := NULL;
                  END IF;
                  --> Chama a package para inserção
                  --
                  IF l_rRet_Reason_line.Reason_Code <> 0 THEN

                    mdb_ar_ret_load_iface_pk.insert_row_p(l_rRet_Reason_line);
                  END IF;

                END IF; --IF MOD(l_nCount, 2) = 0 THEN

                IF l_nCount = 1 THEN
                  l_rRet_Reason_line.Bank_Number          := '341';
                  l_rRet_Reason_line.Document_Id          := substr(l_vFile_Line, 38, 25);
                  l_rRet_Reason_line.Bank_Occurrence_Code := substr(l_vFile_Line, 109, 2);
                  --> Verifica se a data da Ocorrência é nula
                  --
                  IF substr(l_vFile_Line, 111, 6) <> '000000' THEN
                    l_rRet_Reason_line.Occurrence_Date := to_date(substr(l_vFile_Line, 111, 6), 'dd/mm/yy');
                  ELSE
                    l_rRet_Reason_line.Occurrence_Date := NULL;
                  END IF;

                  IF l_rRet_Reason_line.Bank_Occurrence_Code = '57' THEN
                    l_rRet_Reason_line.Reason_Code := substr(l_vFile_Line, 302, 4);

                  ELSIF l_rRet_Reason_line.Bank_Occurrence_Code = '24' OR
                        l_rRet_Reason_line.Bank_Occurrence_Code = '25' THEN

                    l_rRet_Reason_line.Reason_Code := substr(l_vFile_Line, 302, 4);
                    --> Verifica se a Data do Motivo é nula.
                    --
                    IF substr(l_vFile_Line, 306, 6) <> '000000' THEN

                      l_rRet_Reason_line.Reason_Date := to_date(substr(l_vFile_Line, 306, 6), 'dd/mm/yy');
                    ELSE

                      l_rRet_Reason_line.Reason_Date := NULL;
                    END IF;

                    l_rRet_Reason_line.Reason_Adit := to_number(substr(l_vFile_Line, 312, 13)) / 100;

                    IF l_rRet_Reason_line.Reason_Adit = '0' THEN
                      l_rRet_Reason_line.Reason_Adit := NULL;
                    END IF;

                  END IF;

                  IF l_rRet_Reason_line.Bank_Occurrence_Code = '33' OR
                    l_rRet_Reason_line.Bank_Occurrence_Code = '34' OR
                    l_rRet_Reason_line.Bank_Occurrence_Code = '35' OR
                    l_rRet_Reason_line.Bank_Occurrence_Code = '36' THEN

                    l_rRet_Reason_line.Reason_Value := to_number(substr(l_vFile_Line, 176, 13)) / 100;
                    --> Chama a package para inserção quando ocorrer despesas cartorárias
                    --
                    mdb_ar_ret_load_iface_pk.insert_row_p(l_rRet_Reason_line);
                    l_rRet_Reason_line.Reason_Code := NULL;
                  END IF;

                  --> Chama a package para inserção
                  --
                  IF l_rRet_Reason_line.Reason_Code <> 0  THEN
                    mdb_ar_ret_load_iface_pk.insert_row_p(l_rRet_Reason_line);
                  END IF;

                  --> Se o primeiro codigo de motivo for nulo, insere uma linha e sai
                  --
                  IF l_rRet_Reason_line.Reason_Code IS NULL THEN
                  --\ Alt. 13/11/2006
                  --IF nvl(l_rRet_Reason_line.Reason_Code,0) = 0 THEN
                  --\ Alt. 15/11/2006
                    EXIT;
                  END IF;

                END IF;

              END LOOP; --FOR l_nCount IN 1.. 8 LOOP

            END IF; --IF p_bank_number = '001' THEN

          END IF; --IF substr(l_vFile_Line, 1, 1) = '1' THEN

        END IF; --IF NOT substr(l_vFile_Line, 1, 1) = 'O' OR substr(l_vFile_Line, 1, 1) = '9' THEN

      END;

    END LOOP;

    utl_file.fclose(l_fTransfer_File);

    EXCEPTION
      WHEN OTHERS THEN
        fnd_file.put_line(fnd_file.log, 'Ocorreu um erro na package mdb_ar_ret_load_iface: ' || SQLERRM);
        RAISE_APPLICATION_ERROR(-20006, 'Ocorreu um erro na package mdb_ar_ret_load_iface: ' ||SQLERRM);
  END;


  PROCEDURE insert_row_p (p_ret_reason_reg IN mdb_ar_ret_reason_all%ROWTYPE) IS

    l_rRet_Reason_line mdb_ar_ret_reason_all%ROWTYPE := p_ret_reason_reg;
    --> Faz a inserção dos dados recebidos da leitura do arquivo.
    --
    BEGIN

      l_rRet_Reason_line.Last_Update_Date  := SYSDATE;
      l_rRet_Reason_line.Last_Updated_By   := fnd_global.user_id;
      l_rRet_Reason_line.Last_Update_Login := fnd_global.login_id;
      l_rRet_Reason_line.Creation_Date     := SYSDATE;
      l_rRet_Reason_line.Created_By        := fnd_global.user_id;

      INSERT INTO mdb_ar_ret_reason_all
      VALUES l_rRet_Reason_line;
      COMMIT;
      EXCEPTION
        WHEN OTHERS THEN
          fnd_file.put_line(fnd_file.log, 'Erro ao inserir os dados na tabela mdb_ar_ret_reason_all: ' || SQLERRM);
    END;
    --
    -- $Header$
    --
END mdb_ar_ret_load_iface_pk;
/

EXIT;

