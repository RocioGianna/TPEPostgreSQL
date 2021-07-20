--DROP TABLAS--
DROP TABLE GR09_ALQUILA CASCADE;
DROP TABLE GR09_CLIENTE CASCADE;
DROP TABLE GR09_OFICINA CASCADE;
DROP TABLE GR09_OFICINA_REG CASCADE;
DROP TABLE GR09_SALA_CONVENCION CASCADE;
--DROP TRIGGER--
DROP TRIGGER IF EXISTS tr_gr09_registro_alquileres_update ON gr09_alquila CASCADE;
DROP TRIGGER IF EXISTS tr_gr09_registro_alquileres_insert ON gr09_alquila CASCADE;
DROP TRIGGER IF EXISTS tr_gr09_registro_alquileres_delete ON gr09_alquila CASCADE;
DROP TRIGGER IF EXISTS tr_gr09_oficina_regular ON gr09_v_oficinas_reg CASCADE;
DROP TRIGGER IF EXISTS tr_gr09_sala_convencion ON gr09_sala_convencion CASCADE;
--DROP FUNCTIONS--
DROP FUNCTION IF EXISTS fn_gr09_actualizar_registros_oficinas() CASCADE;
DROP FUNCTION IF EXISTS fn_gr09_oficina_regular() CASCADE;
DROP FUNCTION IF EXISTS fn_gr09_sala_convencion() CASCADE;
--DROP VISTAS--
DROP VIEW gr09_v_clientes_comp  CASCADE;
DROP VIEW gr09_v_oficinas_reg CASCADE;
DROP VIEW gr09_v_oficina_regular CASCADE;
DROP VIEW gr09_v_sala_convencion CASCADE;


