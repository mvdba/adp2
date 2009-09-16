WHENEVER SQLERROR EXIT FAILURE ROLLBACK
CONNECT &1/&2

WHENEVER SQLERROR CONTINUE

DROP PACKAGE mdb_ar_ret_load_iface;

CREATE OR REPLACE PACKAGE mdb_ar_ret_load_iface_pk AUTHID CURRENT_USER IS
--
-- $Header: MDB_AR_RET_LOAD_IFACE_PKS.pls 115.14 2006-11-27 20:47:41 -0300 marcus.ferreira svnid_4774 $
-- $Id: MDB_PKS.pls 7903 2007-01-15 22:09:21Z marcus.ferreira $

  PROCEDURE ret_bank_load_iface_p(errbuf            OUT VARCHAR2
                                , retcode           OUT NUMBER
                                , p_bank_number     IN NUMBER
                                , p_balancing_seg   IN VARCHAR2
                                , p_location        IN VARCHAR2
                                , p_file_name       IN VARCHAR2
                                , p_set_of_books_id IN NUMBER);

  PROCEDURE insert_row_p (p_ret_reason_reg IN mdb_ar_ret_reason_all%ROWTYPE);


END mdb_ar_ret_load_iface_pk;
/

EXIT;

