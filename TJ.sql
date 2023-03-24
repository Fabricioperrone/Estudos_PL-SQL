




                                      create or replace package body GERA_DADOS_TCE_PKG is
  G_CodComarca    PROCESSO.COD_COMARCA%type;
  G_DtAberturaInq date := Null;
  G_Arquivo       varchar2(30);

  /*-------------------------------------------------------------------------------------------*/
  PROCEDURE INSERE_TCE_PROCESSOS_CRIMINAIS IS
  begin
    for Cproc in (select distinct p.cod_comarca,
                                  p.numero_processo,
                                  p.tjid_numero_processo,
                                  p.tjid_classe,
                                  p.tjid_assunto_principal,
                                  p.cod_classe,
                                  p.cod_natureza,
                                  p.cod_orgao_julgador_ultdistrib,
                                  jp.dt_inicio_jud_proc,
                                  jp.cod_orgao_julgador,
                                  p.situacao_processo,
                                  p.data_propositura,
                                  decode (Extract(Year From p.data_denuncia),
                                           1800,
                                           null,
                                           to_char(p.data_denuncia, 'dd/mm/yyyy')) vdata_denuncia,
                                  decode (Extract(Year From p.data_baixa),
                                          1800,
                                          null,
                                          to_char(p.data_baixa, 'dd/mm/yyyy')) vdata_baixa,
                                  tb.nome,
                                  p.numero_proc_princ,
                                  p.processo_anterior,
                                  FORMATA_PROCESSO(p.cod_comarca,
                                                   p.numero_processo) vprocesso_formatado,
                                  FORMATA_PROCESSO_CNJ(p.tjid_numero_processo) vprocessocnj_formatado,
                                  /*** Busca data da distribuição do Processo na tabela MOVIMENTO_PROCESSO, código 8000 (Processo Distribuido) ***/
                                  (select data_criacao_movimento
                                     from central.movimento_processo@bi mp
                                    where mp.cod_comarca = p.cod_comarca
                                      and mp.numero_processo =
                                          p.numero_processo
                                      and mp.cod_movimento = 8000
                                      and rownum = 1) vdthora_distribuicao,
                                  cc.nome vnome_classecnj,
                                  ca.nome vnome_assuntocnj,
                                  ct.nome vnome_classethemis,
                                  nt.nome vnome_naturezathemis,
                                  oj.nome_extenso vnome_orgao_julgador,
                                  c.nome_extenso vnome_comarca,
                                  s.nome vsituacao_processo,
                                  decode(segredojustica(p.ind_segredo_justica, cnat.segredo_justica,
                                                        p.cod_especializacao),
                                         'S',
                                         'Sim',
                                         'N',
                                         'Não',
                                         '',
                                         'Não',
                                         '') vsegredo_justica
                    from (select distinct ip.cod_comarca, ip.numero_processo
                            from central.inquerito_processo@bi ip
                            join central.inquerito@bi i
                              on i.cod_inquerito = ip.cod_inquerito
                           where i.dt_abertura >= G_DtAberturaInq
                             and ((G_CodComarca = 0 and ip.cod_comarca > G_CodComarca) or
                                  (G_CodComarca > 0 and ip.cod_comarca = G_CodComarca)) ) x
                    join central.processo@bi p
                      on p.cod_comarca = x.cod_comarca
                     and p.numero_processo = x.numero_processo
                    join central.classe_natureza@bi cnat
                      on p.cod_classe = cnat.cod_classe
                     and p.cod_natureza = cnat.cod_natureza
                    join central.orgao_julgador@bi oj
                      on oj.cod_orgao_julgador =
                         p.cod_orgao_julgador_ultdistrib
                    join central.orgao_julgador@bi c
                      on c.cod_orgao_julgador = p.cod_comarca
                    join central.situacao@bi s
                      on s.cod_situacao = p.cod_situacao_atual
                    left join central.baixa_processo@bi bp
                      on bp.cod_comarca = p.cod_comarca
                     and bp.numero_processo = p.numero_processo
                     and bp.situacao_registro = 'A'
                    left join central.tipo_baixa@bi tb
                      on tb.cod_tipo_baixa = bp.cod_tipo_baixa
                    left join central.judicancia_processo@bi jp
                      on jp.cod_comarca = p.cod_comarca
                     and jp.numero_processo = p.numero_processo
                     and nvl(jp.dt_termino, sysdate) >= sysdate
                    left join central.cnj_classe@bi cc
                      on cc.tjid_classe = p.tjid_classe
                    left join central.cnj_assunto@bi ca
                      on ca.tjid_assunto = p.tjid_assunto_principal
                    left join central.classe@bi ct
                      on ct.cod_classe = p.cod_classe
                    left join central.natureza@bi nt
                      on nt.cod_natureza = p.cod_natureza)
    loop

      dbms_output.put_line('Processo' || '=' || Cproc.numero_processo ||
                           ' / ' || 'Comarca' || '=' || Cproc.cod_comarca);

      /*** Insere o processo na tabela TCE_PROCESSOS_CRIMINAIS ***/

      INSERT INTO TCE_PROCESSOS_CRIMINAIS
        (COD_COMARCA,
         NUMERO_PROCESSO,
         NUM_PROC,
         NUM_PROC_CNJ,
         CLAS_CNJ,
         ASSUN_CNJ,
         CLAS_THEMIS,
         NAT_THEMIS,
         ORG_JULG,
         COMARCA,
         SIT_PROC,
         SEG_JUS,
         DTH_DISTR,
         DT_PROP,
         DT_DENUN,
         DT_SENT,
         DT_BAIXA,
         TP_BAIXA,
         DT_INI_JUDIC,
         NUM_PROC_PRINC,
         NUM_PROC_ANT)
      VALUES
        (Cproc.cod_comarca,
         Cproc.numero_processo,
         Cproc.vprocesso_formatado,
         Cproc.vprocessocnj_formatado,
         Cproc.tjid_classe || ' - ' || Cproc.vnome_classecnj,
         Cproc.tjid_assunto_principal || ' - ' || Cproc.vnome_assuntocnj,
         Cproc.cod_classe || ' - ' || Cproc.vnome_classethemis,
         Cproc.cod_natureza || ' - ' || Cproc.vnome_naturezathemis,
         Cproc.vnome_orgao_julgador,
         Cproc.vnome_comarca,
         Cproc.vsituacao_processo,
         Cproc.vsegredo_justica,
         Cproc.vdthora_distribuicao,
         Cproc.data_propositura,
         Cproc.vdata_denuncia,
         null,
         Cproc.vdata_baixa,
         Cproc.nome,
         trunc(Cproc.dt_inicio_jud_proc),
         Cproc.numero_proc_princ,
         Cproc.processo_anterior);

    end loop;

  end;

  /*------------------------------------------------------------------------------------------*/
  PROCEDURE INSERE_TCE_MOVTOS_PROCESSOS IS
  begin
    for Cproc in (select pc.cod_comarca,
                         pc.numero_processo,
                         FORMATA_PROCESSO(pc.cod_comarca,
                                          pc.numero_processo) vprocesso_formatado,
                         mp.num_movimento,
                         mp.data_movimento,
                         m.nome vnome_movimento,
                         mp.ds_movimento_cnj,
                         mp.cod_movimento,
                         mp.cod_situacao,
                         mp.complemento,
                         s.nome vnome_situacao,
                         decode (Extract(Year From mp.data_exclusao),
                                 1800,
                                 null,
                                 to_char(mp.data_exclusao, 'dd/mm/yyyy')) vdata_exclusao
                  from tce_processos_criminais pc
                    join central.movimento_processo@bi mp on mp.cod_comarca = pc.cod_comarca
                                                         and mp.numero_processo = pc.numero_processo
                    join central.movimento@bi m on m.cod_movimento = mp.cod_movimento
                    join central.situacao@bi s on s.cod_situacao = mp.cod_situacao
                   where pc.cod_comarca = G_CodComarca)

    loop
      dbms_output.put_line('Processo' ||'='||Cproc.numero_processo ||' / '|| 'Comarca' ||'='||Cproc.cod_comarca);

   /*** Insere os movimentos do processo na tabela TCE_MOVIMENTACOES_PROCESSOS ***/

      INSERT INTO TCE_MOVIMENTACOES_PROCESSOS
             (COD_COMARCA,
              NUMERO_PROCESSO,
              NUM_MOVIMENTO,
              NUM_PROC,
              DTH_MOV,
              MOV_THEMIS,
              MOV_CNJ,
              COMPLEM_MOV,
              SIT_MOV,
              DTH_EXCL)
      VALUES (Cproc.cod_comarca,
              Cproc.numero_processo,
              Cproc.num_movimento,
              Cproc.vprocesso_formatado,
              Cproc.data_movimento,
              Cproc.vnome_movimento,
              Cproc.ds_movimento_cnj,
              Cproc.complemento,
              Cproc.vnome_situacao,
              Cproc.vdata_exclusao);
    end loop;

  end;

  /*------------------------------------------------------------------------------------------*/
  PROCEDURE INSERE_TCE_PROC_POLICIAIS IS
  begin
    for Cproc in (select pc.cod_comarca,
                         pc.numero_processo,
                         i.cod_inquerito,
                         FORMATA_PROCESSO(pc.cod_comarca,
                                          pc.numero_processo) vprocesso_formatado,
                         i.num_inquerito,
                         i.ano_inquerito,
                         decode (i.num_inquerito,
                                 null,
                                 '',
                                 '/') vbarra_inquerito,
                         decode (substr (TO_CHAR (pc.numero_processo), 1, 1),
                                 '5',
                                 i.num_inquerito,
                                 '') vnum_boc,
                         decode (substr (TO_CHAR (pc.numero_processo), 1, 1),
                                 '5',
                                 i.ano_inquerito,
                                 '') vano_boc,
                         case
                           when (substr (TO_CHAR (pc.numero_processo), 1, 1)) = '5' and i.num_inquerito is not null then '/'
                           else ''
                           end vbarra_boc,
                         i.num_oficio,
                         i.ano_oficio,
                         decode (i.num_oficio,
                                 null,
                                 '',
                                 '/') vbarra_oficio,
                         i.dt_abertura,
                         decode(i.tipo_inquerito,
                                '1',
                                'Policial',
                                '2',
                                'Militar',
                                '3',
                                'Administrativo',
                                '4',
                                'Outros',
                                '5',
                                'Acidente de Trânsito e Contravenção',
                                '6',
                                'TC',
                                '7',
                                'Brigada Militar',
                                '') vnome_inquerito,
                                pi.cod_ocor_policial,
                                pi.num_ocor_policial,
                                pi.ano_ocor_policial,
                                i.cod_delegacia,
                                d.nome
                    from tce_processos_criminais pc
                      join central.inquerito_processo@bi ip on ip.cod_comarca = pc.cod_comarca
                                                           and ip.numero_processo = pc.numero_processo
                      join central.inquerito@bi i on i.cod_inquerito = ip.cod_inquerito
                                                 and i.cod_comarca   = ip.cod_comarca
                      join CENTRAL.OCOR_POLICIAL_INQUERITO@BI pi on pi.cod_inquerito = i.cod_inquerito
                                                                and pi.cod_comarca = i.cod_comarca
                                                                and pi.situacao_registro = 'A'
                      left join central.delegacia@bi d on d.cod_delegacia = i.cod_delegacia
                    where pc.cod_comarca = G_CodComarca)
    loop

     dbms_output.put_line('Processo' ||'='||Cproc.numero_processo ||' / '|| 'Comarca' ||'='||Cproc.cod_comarca);

  /*** Insere os inquéritos do processo na tabela TCE_PROCEDIMENTOS_POLICIAIS ***/

     INSERT INTO TCE_PROCEDIMENTOS_POLICIAIS
                  (COD_COMARCA,
                   NUMERO_PROCESSO,
                   COD_INQUERITO,
                   COD_OCOR_POLICIAL,
                   NUM_PROC,
                   NUM_OCOR,
                   TP_OCOR,
                   DT_ABERT_OCOR,
                   NUM_INQ,
                   NUM_OFICIO,
                   NUM_BOC,
                   DELEGACIA)
     VALUES (Cproc.cod_comarca,
                 Cproc.numero_processo,
                 Cproc.cod_inquerito,
                 Cproc.cod_ocor_policial,
                 Cproc.vprocesso_formatado,
                 Cproc.num_ocor_policial || '/' || Cproc.ano_ocor_policial,
                 Cproc.vnome_inquerito,
                 Cproc.dt_abertura,
                 Cproc.num_inquerito || Cproc.vbarra_inquerito || Cproc.ano_inquerito,
                 Cproc.num_oficio || Cproc.vbarra_oficio || Cproc.ano_oficio,
                 Cproc.vnum_boc || Cproc.vbarra_boc || Cproc.vano_boc,
                 Cproc.cod_delegacia || ' - ' || Cproc.nome);
    end loop;

  end;

  /*----------------------------------------------------------------------------------------------*/
  PROCEDURE INSERE_TCE_AUDIENCIAS IS
  begin
    for Cproc in (select pc.cod_comarca,
                         pc.numero_processo,
                         ap.num_movimento,
                         FORMATA_PROCESSO(pc.cod_comarca,
                                          pc.numero_processo) vprocesso_formatado,
                         ap.dt_audiencia,
                         m.nome,
                         decode(ap.resultado,
                                'R',
                                'Realizada',
                                'T',
                                'Transferida',
                                'C',
                                'Cancelada',
                                'N',
                                'Não Realizada',
                                '') vresultado,
                         ap.qtde_arrolados,
                         ap.qtde_cientificados,
                         ap.qtde_ouvidos
                  from tce_processos_criminais pc
                  join central.audiencia_processo@bi ap on ap.cod_comarca = pc.cod_comarca
                                                       and ap.numero_processo = pc.numero_processo
                  left join central.movimento_processo@bi mp on mp.cod_comarca = pc.cod_comarca
                                                            and mp.numero_processo = pc.numero_processo
                                                            and mp.num_movimento = ap.num_movimento
                  left join central.movimento@bi m on m.cod_movimento = mp.cod_movimento
                    where pc.cod_comarca = G_CodComarca)
    loop

     dbms_output.put_line('Processo' ||'='||Cproc.numero_processo ||' / '|| 'Comarca' ||'='||Cproc.cod_comarca);

  /*** Insere as audiências do processo na tabela TCE_AUDIENCIAS ***/

      INSERT INTO TCE_AUDIENCIAS
                  (COD_COMARCA,
                   NUMERO_PROCESSO,
                   NUM_MOVIMENTO,
                   NUM_PROC,
                   DTH_AUD,
                   TP_AUD,
                   RES_AUD,
                   QTD_PES_ARROL,
                   QTD_PES_CIENT,
                   QTD_PES_OUV)
      VALUES (Cproc.cod_comarca,
              Cproc.numero_processo,
              Cproc.num_movimento,
              Cproc.vprocesso_formatado,
              Cproc.dt_audiencia,
              Cproc.nome,
              Cproc.vresultado,
              Cproc.qtde_arrolados,
              Cproc.qtde_cientificados,
              Cproc.qtde_ouvidos);
    end loop;

  end;

  /*----------------------------------------------------------------------------------------------*/
  PROCEDURE INSERE_TCE_CARGAS_PROCESSOS IS
  begin
    for Cproc in (select cp.cod_comarca,
                         cp.numero_processo,
                         cp.num_movimento,
                         FORMATA_PROCESSO(pc.cod_comarca,
                                          pc.numero_processo) vprocesso_formatado,
                         tc.nome,
                         cp.num_dias_carga,
                         cp.data_carga,
                         cp.data_previsao_devolucao,
                         cp.data_devolucao,
                         decode (Extract(Year From mp.data_exclusao),
                                 1800,
                                 null,
                                 to_char(mp.data_exclusao, 'dd/mm/yyyy')) vdata_exclusao
                    from central.carga_processo@bi cp
                      join tce_processos_criminais pc on pc.cod_comarca = cp.cod_comarca
                                                     and pc.numero_processo = cp.numero_processo
                      left join tipo_carga tc on tc.cod_tipo_carga = cp.cod_tipo_carga
                      join central.movimento_processo@bi mp on mp.cod_comarca = cp.cod_comarca
                                                           and mp.numero_processo = cp.numero_processo
                                                           and mp.num_movimento = cp.num_movimento
                    where cp.cod_comarca = G_CodComarca)
    loop

     dbms_output.put_line('Processo' ||'='||Cproc.numero_processo ||' / '|| 'Comarca' ||'='||Cproc.cod_comarca);

  /*** Insere as cargas de processos na tabela TCE_CARGAS_PROCESSOS ***/

     INSERT INTO TCE_CARGAS_PROCESSOS
                  (COD_COMARCA,
                   NUMERO_PROCESSO,
                   NUM_MOVIMENTO,
                   NUM_PROC,
                   TP_CARGA,
                   PRAZO,
                   DT_CARGA,
                   DEVOLVER_EM,
                   DEVOLVIDO_EM,
                   DTH_EXCL)
     VALUES (Cproc.cod_comarca,
             Cproc.numero_processo,
             Cproc.num_movimento,
             Cproc.vprocesso_formatado,
             Cproc.nome,
             Cproc.num_dias_carga,
             Cproc.data_carga,
             Cproc.data_previsao_devolucao,
             Cproc.data_devolucao,
             Cproc.vdata_exclusao);
    end loop;

  end;

  /*-------------------------------------------------------------------------------------------------------*/
  PROCEDURE INSERE_TCE_PARTES IS
  begin
    for Cproc in (select p.cod_comarca,
                         p.numero_processo,
                         p.id_parte,
                         FORMATA_PROCESSO(p.cod_comarca,
                                          p.numero_processo) vprocesso_formatado,
                         d.nome_masc,
                        (select
                          case
                            when ad.num_oab = 'DEFPUB' /*and ad.uf_oab = 'RS'*/ then 'Defensor Publico'
                            when (ad.num_oab = '' or ad.num_oab is null) /*and ad.uf_oab = 'RS'*/ then 'Ministerio Publico'
                            when ad.num_oab > '0' /*and ad.uf_oab = 'RS'*/ and
                                (sp.id_pessoa_juridica_oab is null or sp.id_pessoa_juridica_oab = 0) then 'Advogado'
                            when ad.num_oab > '0' /*and ad.uf_oab = 'RS'*/ and sp.id_pessoa_juridica_oab > 0 then 'Sociedade'
                          else ''
                          end vtipo_advogado
                         from central.advogado_parte@bi ap
                            left join central.advogado@bi ad on ad.cod_comarca = ap.cod_comarca
                                                            and ad.id_advogado = ap.id_advogado
                            left join central.sociedade_parte@bi sp on sp.cod_comarca = ap.cod_comarca
                                                                  and  sp.numero_processo = ap.numero_processo
                                                                  and  sp.id_parte = ap.id_parte
                          where ap.cod_comarca = p.cod_comarca
                            and ap.numero_processo = p.numero_processo
                            and ap.id_parte = p.id_parte
                            and ap.situacao_registro = 'A'
                            and rownum = 1) vnome_tipo_advogado,
                         decode(p.ind_reu_preso,
                                'S',
                                'Sim',
                                'N',
                                'Não',
                                 null,
                                'Não',
                                '') vind_reu_preso,
                         decode (Extract(Year from p.data_denuncia),
                                 1800,
                                 null,
                                 to_char(p.data_denuncia, 'dd/mm/yyyy')) vdata_denuncia,
                         decode(p.cod_designacao,
                                '201',
                                'Sim',
                                '202',
                                'Sim',
                                'Não') vreu_menor,
                         decode (Extract(Year from p.data_baixa),
                                 1800,
                                 null,
                                 to_char(p.data_baixa, 'dd/mm/yyyy')) vdata_baixa,
                         ep.descricao,
                         decode (Extract(Year from p.data_baixa_condenacao),
                                 1800,
                                 null,
                                 to_char(p.data_baixa_condenacao, 'dd/mm/yyyy')) vdata_baixa_condenacao,
                         p.motivo_baixa_condenacao,
                         decode (Extract(Year from p.data_exclusao),
                                 1800,
                                 null,
                                 to_char(p.data_exclusao, 'dd/mm/yyyy')) vdata_exclusao,
                                 p.motivo_excl
                    from central.parte@bi p
                      left join central.designacao@bi d on d.cod_designacao = p.cod_designacao
                      left join motivo_exclusao_parte ep on ep.cod_motivo = p.cod_motivo_baixa
                      join tce_processos_criminais pc on pc.cod_comarca = p.cod_comarca
                                                     and pc.numero_processo = p.numero_processo
                     where p.cod_comarca = G_CodComarca)
    loop

     dbms_output.put_line('Processo' ||'='||Cproc.numero_processo ||' / '|| 'Comarca' ||'='||Cproc.cod_comarca);

  /*** Insere as partes do processo na tabela TCE_PARTES ***/

     INSERT INTO TCE_PARTES
                  (COD_COMARCA,
                   NUMERO_PROCESSO,
                   ID_PARTE,
                   NUM_PROC,
                   DESIG,    -- Exemplo: masc. Autor, Réu, Vítima, etc.
                   TP_ADVOG, -- Exemplo: Defensor Público, Advogado, etc.
                   REU_PRESO,
                   DT_DENUN,
                   REU_MENOR,
                   DTH_BAIXA_PARTE,
                   MOT_BAIXA_PARTE,
                   DT_BAIXA_COND,
                   MOT_BAIXA_COND,
                   DTH_EXCL,
                   MOT_EXCL)
     VALUES (Cproc.cod_comarca,
             Cproc.numero_processo,
             Cproc.id_parte,
             Cproc.vprocesso_formatado,
             Cproc.nome_masc,
             Cproc.vnome_tipo_advogado,
             Cproc.vind_reu_preso,
             Cproc.vdata_denuncia,
             Cproc.vreu_menor,
             Cproc.vdata_baixa,
             Cproc.descricao,
             Cproc.vdata_baixa_condenacao,
             Cproc.motivo_baixa_condenacao,
             Cproc.vdata_exclusao,
             Cproc.motivo_excl);
    end loop;

  end;

  /*----------------------------------------------------------------------------------------------*/
  PROCEDURE INSERE_TCE_SENTENCAS IS
  begin
    for Cproc in (select sp.cod_comarca,
                         sp.numero_processo,
                         sp.num_movimento,
                         FORMATA_PROCESSO(sp.cod_comarca,
                                          sp.numero_processo) vprocesso_formatado,
                         m.nome,
                         decode(sp.grau_jurisdicao,
                                '1',
                                '1º Grau',
                                '2',
                                '2º Grau',
                                '') vjurisdicao,
                         decode(sp.ind_originaria,
                                'S',
                                'Sim',
                                'N',
                                'Não',
                                '',
                                'Não',
                                '')voriginaria,
                         decode(sp.ind_reformada,
                                'S',
                                'Sim',
                                'N',
                                'Não',
                                '',
                                'Não',
                                '') vreformada,
                         decode(Extract(Year From sp.data_anulacao),
                                        1800,
                                        'Não',
                                        '',
                                        'Não',
                                        'Sim') vanulada,
                         --NOME_JULGADOR (sp.cod_julgador) vnome_julgador,
                         pe.nome vnome_julgador,
                         sp.data_sentenca,
                         decode (Extract(Year from pa.data_transito),
                                 1800,
                                 null,
                                 to_char(pa.data_transito, 'dd/mm/yyyy')) vdata_transito,
                         sp.id_parte
                    from central.sentenca_processo@bi sp
                      join tce_partes p on p.cod_comarca = sp.cod_comarca
                                       and p.numero_processo = sp.numero_processo
                                       and p.id_parte = sp.id_parte
                      join central.parte@bi pa on pa.cod_comarca = sp.cod_comarca
                                              and pa.numero_processo = sp.numero_processo
                                              and pa.id_parte = sp.id_parte
                      join central.movimento_processo@bi mp on mp.cod_comarca = sp.cod_comarca
                                                           and mp.numero_processo = sp.numero_processo
                                                           and mp.num_movimento = sp.num_movimento
                      left join central.movimento@bi m on m.cod_movimento = mp.cod_movimento
                      left join central.pessoa@bi pe on pe.cod_pessoa = sp.cod_julgador
                                                   and  pe.cod_comarca = sp.cod_comarca

                    where sp.cod_comarca = G_CodComarca
                      and sp.situacao_sentenca in ('A', 'N'))
    loop

     dbms_output.put_line('Processo' ||'='||Cproc.numero_processo ||' / '|| 'Comarca' ||'='||Cproc.cod_comarca);

  /*** Insere as sentenças do processo na tabela TCE_SENTENCA ***/

     INSERT INTO TCE_SENTENCAS
                  (COD_COMARCA,
                   NUMERO_PROCESSO,
                   NUM_MOVIMENTO,
                   NUM_PROC,
                   TP_SENT,
                   JURISDICAO,
                   ORIGINARIA,
                   REFORMADA,
                   ANULADA,
                   JULGADOR,
                   PROFERIDA_EM,
                   TRANSITO,
                   ID_PARTE)
     VALUES (Cproc.cod_comarca,
             Cproc.numero_processo,
             Cproc.num_movimento,
             Cproc.vprocesso_formatado,
             Cproc.nome,
             Cproc.vjurisdicao,
             Cproc.voriginaria,
             Cproc.vreformada,
             Cproc.vanulada,
             Cproc.vnome_julgador,
             Cproc.data_sentenca,
             Cproc.vdata_transito,
             Cproc.id_parte);
    end loop;

  end;

  /*-----------------------------------------------------------------------------------------------------------*/
  PROCEDURE INSERE_TCE_PENAS_MEDIDAS IS
  begin
    for Cproc in (select s.cod_comarca,
                         s.numero_processo,
                         s.num_movimento,
                         pr.id_parte,
                         pr.num_pena_reu,
                         FORMATA_PROCESSO(s.cod_comarca,
                                          s.numero_processo) vprocesso_formatado,
                         tp.nome,
                         case
                          when substr (TO_CHAR (pr.numero_processo), 1, 1) = '5' and tp.tipo_pena = 'E' then 'Socioeducativa'
                          when substr (TO_CHAR (pr.numero_processo), 1, 1) = '5' and tp.tipo_pena = 'T' then 'Protetiva'
                          when substr (TO_CHAR (pr.numero_processo), 1, 1) = '2' and pr.numero_processo_pai is not null then 'Substitutiva'
                          when substr (TO_CHAR (pr.numero_processo), 1, 1) = '2' and pr.numero_processo_pai is null then 'Principal'
                         else ''
                         end vtipo_pena,
                         pr.ano_pena_cumprir,
                         pr.mes_pena_cumprir,
                         pr.dias_pena_cumprir,
                         pr.hora_pena_cumprir,
                         pr.hora_semana_cumprir,
                         decode (pr.tipo_regime_pena,
                                 '1',
                                 'Aberto',
                                 '2',
                                 'Semi-aberto',
                                 '3',
                                 'Fechado Inicialmente',
                                 '4',
                                 'Fechado Integralmente',
                                 '') vtipo_regime_pena,
                         pr.complemento_pena
                    from tce_sentencas s
                       join central.pena_reu@bi pr on pr.cod_comarca = s.cod_comarca
                                                  and pr.numero_processo = s.numero_processo
                                                  and pr.num_movimento = s.num_movimento
                       left join tipo_pena_reu tp on tp.cod_pena = pr.cod_pena

                     where s.cod_comarca = G_CodComarca)

    loop

     dbms_output.put_line('Processo' ||'='||Cproc.numero_processo ||' / '|| 'Comarca' ||'='||Cproc.cod_comarca);

     /*** Insere as penas e medidas vinculadas às Sentenças dos Processos na tabela TCE_PENAS_MEDIDAS ***/

     INSERT INTO TCE_PENAS_MEDIDAS
                  (COD_COMARCA,
                   NUMERO_PROCESSO,
                   NUM_MOVIMENTO,
                   ID_PARTE,
                   NUM_PENA_REU,
                   NUM_PROC,
                   PENA_MEDIDA,
                   TP_PENA_MEDIDA,
                   ANOS_CUMPRIR,
                   MESES_CUMPRIR,
                   DIAS_CUMPRIR,
                   HORAS_CUMPRIR,
                   HORAS_SEMANAIS,
                   REGIME,
                   COMPLEM)
     VALUES (Cproc.cod_comarca,
             Cproc.numero_processo,
             Cproc.num_movimento,
             Cproc.id_parte,
             Cproc.num_pena_reu,
             Cproc.vprocesso_formatado,
             Cproc.nome,
             Cproc.vtipo_pena,
             Cproc.ano_pena_cumprir,
             Cproc.mes_pena_cumprir,
             Cproc.dias_pena_cumprir,
             Cproc.hora_pena_cumprir,
             Cproc.hora_semana_cumprir,
             Cproc.vtipo_regime_pena,
             Cproc.complemento_pena);
    end loop;

  end;

  /*-----------------------------------------------------------------------------------------------------------*/
  PROCEDURE INSERE_TCE_PRISOES_INTERNACOES IS
  begin
    for Cproc in (select pa.cod_comarca,
                         pa.numero_processo,
                         mp.num_movimento,
                         pa.id_parte,
                         pr.num_prisao,
                         mp.num_mov_prisao,
                         FORMATA_PROCESSO(pa.cod_comarca,
                                          pa.numero_processo) vprocesso_formatado,
                         mp.dt_inicio,
                         mp.dt_termino,
                         m.nome vnome_encerr,
                         lr.nome local_recolhimento,
                         cd.nome casa_detencao,
                         decode (substr (TO_CHAR (pa.numero_processo), 1, 1),
                                 '5',
                                 lr.nome,
                                 '2',
                                 cd.nome,
                                 '') vcasa_pris_intern,
                         case
                          when substr (TO_CHAR (pa.numero_processo), 1, 1) = '5' and mp.ind_tipo_prisao = 1 then 'Decretação de Internação Provisória'
                          when substr (TO_CHAR (pa.numero_processo), 1, 1) = '5' and mp.ind_tipo_prisao = 2 then 'Apreensão em Flagrante'
                          when substr (TO_CHAR (pa.numero_processo), 1, 1) = '5' and mp.ind_tipo_prisao = 3 then 'Internação Provisória'
                          when substr (TO_CHAR (pa.numero_processo), 1, 1) = '5' and mp.ind_tipo_prisao = 4 then 'Manutenção de Apreensão em Flagrante'
                          when substr (TO_CHAR (pa.numero_processo), 1, 1) = '2' and mp.ind_tipo_prisao = 1 then 'Decretação de Prisão'
                          when substr (TO_CHAR (pa.numero_processo), 1, 1) = '2' and mp.ind_tipo_prisao = 2 then 'Prisão em Flagrante ou Temporária'
                          when substr (TO_CHAR (pa.numero_processo), 1, 1) = '2' and mp.ind_tipo_prisao = 3 then 'Prisão Preventiva'
                          when substr (TO_CHAR (pa.numero_processo), 1, 1) = '2' and mp.ind_tipo_prisao = 4 then 'Manutenção de Prisão em Flagrante'
                         else ''
                         end vmot_pris_intern
                    from tce_partes pa
                     join central.prisao_reu@bi pr on pr.cod_comarca = pa.cod_comarca
                                                  and pr.numero_processo = pa.numero_processo
                                                  and pr.id_parte = pa.id_parte
                                                  and pr.situacao_registro = 'A'
                     join central.movimento_prisao@bi mp on mp.cod_comarca = pr.cod_comarca
                                                        and mp.numero_processo = pr.numero_processo
                                                        and mp.id_parte = pr.id_parte
                                                        and mp.num_prisao = pr.num_prisao
                                                        and mp.situacao_registro = 'A'
                     join central.movimento_processo@bi mr on mr.cod_comarca =  mp.cod_comarca
                                                          and mr.numero_processo = mp.numero_processo
                                                          and mr.num_movimento = mp.num_movimento
                     join central.movimento@bi m on m.cod_movimento = mr.cod_movimento
                     left join local_recolhimento lr on lr.cod_local_recolhe =  pr.cod_local_prisao
                     left join casa_detencao cd on cd.cod_casa_detencao = pr.cod_local_prisao
                    where pa.cod_comarca = G_CodComarca)

    loop

     dbms_output.put_line('Processo' ||'='||Cproc.numero_processo ||' / '|| 'Comarca' ||'='||Cproc.cod_comarca);

     /*** Insere as prisões e internações vinculadas às Partes dos Processos na tabela TCE_PRISOES_INTERNACOES ***/

     INSERT INTO TCE_PRISOES_INTERNACOES
              (COD_COMARCA,
               NUMERO_PROCESSO,
               NUM_MOVIMENTO,
               ID_PARTE,
               NUM_PRISAO,
               NUM_MOV_PRISAO,
               NUM_PROC,
               DT_INI_PRIS_INTERN,
               DT_ENCER_PRIS_INTERN,
               TP_ENCER,
               CASA_PRIS_INTERN,
               MOT_PRIS_INTERN)
     VALUES (Cproc.cod_comarca,
             Cproc.numero_processo,
             Cproc.num_movimento,
             Cproc.id_parte,
             Cproc.num_prisao,
             Cproc.num_mov_prisao,
             Cproc.vprocesso_formatado,
             Cproc.dt_inicio,
             Cproc.dt_termino,
             Cproc.vnome_encerr,
             Cproc.vcasa_pris_intern,
             Cproc.vmot_pris_intern);
    end loop;

  end;

  /*-----------------------------------------------------------------------------------------------------------*/
  PROCEDURE INSERE_TCE_ENQUADRAMENTOS IS
  begin
    for Cproc in (select pa.cod_comarca,
                         pa.numero_processo,
                         pa.id_parte,
                         el.num_enq_legal,
                         FORMATA_PROCESSO(pa.cod_comarca,
                                          pa.numero_processo) vprocesso_formatado,
                         case
                          when substr (TO_CHAR (pa.numero_processo), 1, 1) = '5' and el.tipo_enquadramento = 4 then 'Sentença'
                          when substr (TO_CHAR (pa.numero_processo), 1, 1) = '5' and el.tipo_enquadramento = 5 then 'Acórdão'
                          when substr (TO_CHAR (pa.numero_processo), 1, 1) = '5' and el.tipo_enquadramento = 6 then 'BOC'
                          when substr (TO_CHAR (pa.numero_processo), 1, 1) = '5' and el.tipo_enquadramento = 7 then 'Representação'
                          when substr (TO_CHAR (pa.numero_processo), 1, 1) = '5' and el.tipo_enquadramento = 8 then 'Queixa'
                          when substr (TO_CHAR (pa.numero_processo), 1, 1) = '2' and el.tipo_enquadramento = 1 then 'Inquerito/TC'
                          when substr (TO_CHAR (pa.numero_processo), 1, 1) = '2' and el.tipo_enquadramento = 2 then 'Denúncia/Queixa'
                          when substr (TO_CHAR (pa.numero_processo), 1, 1) = '2' and el.tipo_enquadramento = 3 then 'Pronúncia'
                          when substr (TO_CHAR (pa.numero_processo), 1, 1) = '2' and el.tipo_enquadramento = 4 then 'Sentença'
                          when substr (TO_CHAR (pa.numero_processo), 1, 1) = '2' and el.tipo_enquadramento = 5 then 'Acórdão'
                         else ''
                         end vtipo_enquadramento,
                         el.ordem_apresentacao,
                         decode(l.tipo_legislacao,
                                'D',
                                'Decreto',
                                'L',
                                'Lei',
                                'DL',
                                'Decreto-Lei',
                                '') vtipo_legislacao,
                         l.numero_lei,
                         l.data_lei,
                         l.artigo,
                         l.paragrafo,
                         l.inciso,
                         l.alinea,
                         el.data_delito,
                         el.qtde_incidencia,
                         decode(el.tipo_combinado,
                                '1',
                                'Com agravante',
                                '2',
                                'Com atenuante',
                                '3',
                                'Combinado com',
                                '4',
                                'E',
                                '') vtipo_combinado,
                         decode(el.ind_condenado,
                                'S',
                                'Sim',
                                'N',
                                'Não',
                                '') vind_condenado,
                         el.data_prescricao
                    from tce_partes pa
                       join central.enq_legal_parte@bi el on el.cod_comarca = pa.cod_comarca
                                                         and el.numero_processo = pa.numero_processo
                                                         and el.id_parte = pa.id_parte
                        left join central.legislacao@bi l on l.cod_legislacao = el.cod_legislacao
                      where pa.cod_comarca = G_CodComarca)
    loop

     dbms_output.put_line('Processo' ||'='||Cproc.numero_processo ||' / '|| 'Comarca' ||'='||Cproc.cod_comarca);

     /*** Insere os enquadramentos legais das Partes na tabela TCE_ENQUADRAMENTOS ***/

     INSERT INTO TCE_ENQUADRAMENTOS
                  (COD_COMARCA,
                   NUMERO_PROCESSO,
                   ID_PARTE,
                   NUM_ENQ_LEGAL,
                   NUM_PROC,
                   TP_ENQ,
                   ORD_ENQ,
                   TP_LEGIS,
                   NUM_LEI,
                   DT_LEI,
                   ART,
                   PARAG,
                   INCISO,
                   ALINEA,
                   DT_DELITO,
                   QTD_INCID,
                   COMBINADO,
                   CONDENADO,
                   DT_PRESCRICAO)
     VALUES (Cproc.cod_comarca,
             Cproc.numero_processo,
             Cproc.id_parte,
             Cproc.num_enq_legal,
             Cproc.vprocesso_formatado,
             Cproc.vtipo_enquadramento,
             Cproc.ordem_apresentacao,
             Cproc.vtipo_legislacao,
             Cproc.numero_lei,
             Cproc.data_lei,
             Cproc.artigo,
             Cproc.paragrafo,
             Cproc.inciso,
             Cproc.alinea,
             Cproc.data_delito,
             Cproc.qtde_incidencia,
             Cproc.vtipo_combinado,
             Cproc.vind_condenado,
             Cproc.data_prescricao);
    end loop;

  end;

  /*----------------------------------------------------------------------------------------------------------*/
  PROCEDURE INSERE_TCE_PESSOAS IS
  begin
    for Cproc in (select tp.cod_comarca,
                         tp.numero_processo,
                         tp.id_parte,
                         FORMATA_PROCESSO(tp.cod_comarca,
                                          tp.numero_processo) vprocesso_formatado,
                         pa.nome,
                         pf.nome_mae,
                         pf.nome_pai,
                         pf.cpf,
                         re.cod_rji,
                         pf.rg,
                         pf.cod_uf_rg,
                         pf.dt_nascimento,
                         Extract(Year from pf.dt_nascimento) ano_nasc,
                         decode(pf.sexo,
                                'M',
                                'Masculino',
                                'F',
                                'Feminino',
                                'Feminino') vsexo,
                         ec.nome_masc vestado_civil,
                         decode(pf.cor,
                                '1',
                                'Branca',
                                '2',
                                'Preta',
                                '3',
                                'Mista',
                                '4',
                                'Amarela',
                                '5',
                                'Indiática',
                                '6',
                                'Albina',
                                '') vcor,
                                pr.nome_masc vprofissao,
                                gi.nome_masc vescolaridade,
                                ci.nome vlocal_nasc,
                                pf.cod_uf_nasc,
                                pa.nac_masculina vnacional,
                                decode (pa.ind_falecido,
                                       'S',
                                       'Sim',
                                       'N',
                                       'Não',
                                       'Não') vfalecido
                    from tce_partes tp
                      join central.parte@bi pa on pa.cod_comarca = tp.cod_comarca
                                              and pa.numero_processo = tp.numero_processo
                                              and pa.id_parte = tp.id_parte
                                              and pa.tipo_parte = 'F'
                      join central.parte_fisica@bi pf on pf.cod_comarca = tp.cod_comarca
                                               and pf.numero_processo = tp.numero_processo
                                               and pf.id_parte = tp.id_parte
                      left join CPPES1G.estado_civil ec on ec.cod_estado_civil = pf.cod_estado_civil
                      left join CPPES1G.profissao pr on pr.cod_profissao = pf.cod_profissao
                      left join CPPES1G.grau_instrucao gi on gi.cod_grau_instrucao = pf.cod_grau_instrucao
                      left join CPPES1G.PAIS pa on pa.cod_pais = pf.cod_pais_nasc
                      left join CPPES1G.CIDADE ci on ci.cod_cidade = pf.cod_local_nasc
                      left join reu re on re.cod_reu = pa.cod_comarca_reu
                                      and re.cod_reu = pa.cod_reu
                     where tp.cod_comarca = G_CodComarca)

    loop

     dbms_output.put_line('Processo' ||'='||Cproc.numero_processo ||' / '|| 'Comarca' ||'='||Cproc.cod_comarca);

     /*** Insere as pessoas referentes às partes do processo na tabela TCE_PESSOAS ***/

     INSERT INTO TCE_PESSOAS
                  (COD_COMARCA,
                   NUMERO_PROCESSO,
                   ID_PARTE,
                   NUM_PROC,
                   NOME,
                   NOME_MAE,
                   NOME_PAI,
                   CPF,
                   RJI,
                   RG,
                   RG_UF,
                   DT_NASC,
                   ANO_NASC,
                   SEXO,
                   ESTADO_CIVIL,
                   RACA_COR_PELE,
                   PROFISSAO,
                   ESCOLAR,
                   NATURAL_MUNIC,
                   NATURAL_UF,
                   NACIONAL,
                   FALECIDO)
     VALUES (Cproc.cod_comarca,
             Cproc.numero_processo,
             Cproc.id_parte,
             Cproc.vprocesso_formatado,
             Cproc.nome,
             Cproc.nome_mae,
             Cproc.nome_pai,
             Cproc.cpf,
             Cproc.cod_rji,
             Cproc.rg,
             Cproc.cod_uf_rg,
             Cproc.dt_nascimento,
             Cproc.ano_nasc,
             Cproc.vsexo,
             Cproc.vestado_civil,
             Cproc.vcor,
             Cproc.vprofissao,
             Cproc.vescolaridade,
             Cproc.vlocal_nasc,
             Cproc.cod_uf_nasc,
             Cproc.vnacional,
             Cproc.vfalecido);
    end loop;

  end;

 /*-----------------------------------------------------------------------------------------------------------------------------*/
  FUNCTION VALIDA_TIPO_ARQUIVO RETURN VARCHAR2 AS
  BEGIN

    If G_Arquivo is null then
      return 'Nome do Arquivo a ser gerado deve ser informado no parâmetro.';
    elsif G_CodComarca is null then
      return 'Numero da comarca para busca dos dados deve ser informado no parâmetro.';
    elsif G_DtAberturaInq < '01/01/2006' then
      return 'Data de abertura de Inquérito ' || G_DtAberturaInq || ' deve ser igual ou maior a 01/01/2006.';
    else
      return '';
    End If;

  END;

  /*-----------------------------------------------------------------------------------------------------------------------------*/
  FUNCTION GERA_DADOS_TCE_T1G(pCodComarca    IN PROCESSO.COD_COMARCA%TYPE := Null, /* Passando zero (0) executa qualquer comarca */
                              pDtAberturaInq IN date := Null, /* Data de abertura do Inquérito (Procedimento Policial */
                              pArquivo       IN varchar2, /* Nome da Tabela a ser gerada: TCE_PROCESSOS_CRIMINAIS, TCE_PARTES, ETC. */
                              pErrMsg        OUT varchar2) RETURN BOOLEAN AS
  BEGIN
    G_CodComarca    := pCodComarca;
    G_DtAberturaInq := pDtAberturaInq;
    G_Arquivo       := pArquivo;

    pErrMsg := VALIDA_TIPO_ARQUIVO;

    if pErrMsg is not null then
      return false;
    else
      if G_Arquivo in ('PROCESSOS_CRIMINAIS') then
        INSERE_TCE_PROCESSOS_CRIMINAIS();
      elsif G_Arquivo in ('MOVIMENTACOES_PROCESSOS') then
        INSERE_TCE_MOVTOS_PROCESSOS();
      elsif G_Arquivo in ('PROCEDIMENTOS_POLICIAIS') then
        INSERE_TCE_PROC_POLICIAIS();
      elsif G_Arquivo in ('AUDIENCIAS') then
        INSERE_TCE_AUDIENCIAS();
      elsif G_Arquivo in ('CARGAS_PROCESSOS') then
        INSERE_TCE_CARGAS_PROCESSOS();
      elsif G_Arquivo in ('PARTES') then
        INSERE_TCE_PARTES();
      elsif G_Arquivo in ('SENTENCAS') then
        INSERE_TCE_SENTENCAS();
      elsif G_Arquivo in ('PENAS_MEDIDAS') then
        INSERE_TCE_PENAS_MEDIDAS();
      elsif G_Arquivo in ('PRISOES_INTERNACOES') then
        INSERE_TCE_PRISOES_INTERNACOES();
      elsif G_Arquivo in ('ENQUADRAMENTOS') then
        INSERE_TCE_ENQUADRAMENTOS();
      elsif G_Arquivo in ('PESSOAS') then
        INSERE_TCE_PESSOAS();
      end if;
    end if;
    return true;
  Exception
    when others then
      pErrMsg := sqlerrm;
      return False;
  END GERA_DADOS_TCE_T1G;

END GERA_DADOS_TCE_PKG;