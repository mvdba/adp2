WHENEVER SQLERROR EXIT FAILURE ROLLBACK
CONNECT &1/&2

--
-- $Header: MDB_AR_RET_LOAD_IFACE.sql 115.6 2006-11-27 20:47:41 -0300 marcus.ferreira svnid_4774 $
-- $Id: MDB.sql 7903 2007-01-15 22:09:21Z marcus.ferreira $
--
begin
   fnd_program.delete_program('MDB_AR_RET_LOAD_IFACE',
                              'GMDB Customizacoes');
end;
/
--
begin

  fnd_program.delete_executable('MDB_AR_RET_LOAD_IFACE',
                                'GMDB Customizacoes');
end;
--


COMMIT;

EXIT;

