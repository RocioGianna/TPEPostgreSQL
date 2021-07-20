/*A. TRIGGERS Y SERVICIOS
1. Se le agregala columna cantidad_salas (cantidad de salas de convención) y
cantidad_oficinas (cantidad de oficinas regulares) a la tabla CLIENTE. Es necesario
mantener actualizadas las columnas cantidad_salas y cantidad_oficinas con la cantidad de
salas de convención y oficinas regulares que cada cliente tiene alquiladas por tiempo
indeterminado (es decir que aún no tienen fecha de fin). Se debe realizar con triggers FOR
STATEMENT.*/

create or replace function fn_gr09_actualizar_registros_oficinas() returns trigger as $$
    declare
        tipo_alquiler char;
        tipo_alquiler_viejo char;
        mifila record;
        mifilavieja record;
        num integer;
    begin
        num := 0;
        if( TG_OP = 'INSERT')then
            for mifila in (select * from new_table)
            loop
                if(mifila.fecha_hasta  IS NULL)then
                    select tipo_o into tipo_alquiler
                    from gr09_oficina
                    where id_oficina = mifila.id_oficina;
                    if(tipo_alquiler = 'O') then
                        update gr09_cliente set cantidad_oficinas = cantidad_oficinas + 1 where nro_doc = mifila.nro_doc;
                    else
                        update gr09_cliente set cantidad_salas = cantidad_salas + 1 where nro_doc = mifila.nro_doc;
                    end if;
                end if;
            end loop;
        end if;
        if (TG_OP = 'UPDATE')then
            for mifila in (select * from new_table)
            loop
                select * into mifilavieja from old_table limit 1 offset num;
                select tipo_o into tipo_alquiler
                from gr09_oficina
                where id_oficina = mifila.id_oficina;
                select tipo_o into tipo_alquiler_viejo
                from gr09_oficina
                where id_oficina = mifilavieja.id_oficina;
                if(tipo_alquiler = 'O') then
                    if(mifila.fecha_hasta NOTNULL )then
                        if(tipo_alquiler != tipo_alquiler_viejo)then
                            update gr09_cliente set cantidad_salas = cantidad_salas - 1 where nro_doc = mifilavieja.nro_doc;
                        else
                            update gr09_cliente set cantidad_oficinas = cantidad_oficinas - 1 where nro_doc = mifilavieja.nro_doc;
                        end if;
                    else
                        if(mifila.nro_doc != mifilavieja.nro_doc AND mifila.id_oficina = mifilavieja.id_oficina)then
                            update gr09_cliente set cantidad_oficinas = cantidad_oficinas + 1 where nro_doc = mifila.nro_doc;
                            update gr09_cliente set cantidad_oficinas = cantidad_oficinas - 1 where nro_doc = mifilavieja.nro_doc;
                        elseif(mifila.nro_doc = mifilavieja.nro_doc AND mifila.id_oficina != mifilavieja.id_oficina)then
                                if(tipo_alquiler != tipo_alquiler_viejo)then
                                    update gr09_cliente set cantidad_salas = cantidad_salas - 1 where nro_doc = mifilavieja.nro_doc;
                                    update gr09_cliente set cantidad_oficinas = cantidad_oficinas + 1 where nro_doc = mifila.nro_doc;
                                end if;
                        elseif(mifila.nro_doc != mifilavieja.nro_doc AND mifila.id_oficina != mifilavieja.id_oficina)then
                            if(tipo_alquiler != tipo_alquiler_viejo)then
                                update gr09_cliente set cantidad_salas = cantidad_salas - 1 where nro_doc = mifilavieja.nro_doc;
                                update gr09_cliente set cantidad_oficinas = cantidad_oficinas + 1 where nro_doc = mifila.nro_doc;
                            else
                                update gr09_cliente set cantidad_oficinas = cantidad_oficinas + 1 where nro_doc = mifila.nro_doc;
                                update gr09_cliente set cantidad_oficinas = cantidad_oficinas - 1 where nro_doc = mifilavieja.nro_doc;
                            end if;
                        else
                            update gr09_cliente set cantidad_oficinas = cantidad_oficinas + 1 where nro_doc = mifila.nro_doc;
                        end if;
                    end if;
                       -- end if;
                   -- end if;
                else
                    if(mifila.fecha_hasta NOTNULL )then
                        if(tipo_alquiler != tipo_alquiler_viejo)then
                            update gr09_cliente set cantidad_oficinas = cantidad_oficinas - 1 where nro_doc = mifilavieja.nro_doc;
                        else
                            update gr09_cliente set cantidad_salas = cantidad_salas - 1 where nro_doc = mifilavieja.nro_doc;
                        end if;
                    else
                        if(mifila.nro_doc != mifilavieja.nro_doc AND mifila.id_oficina = mifilavieja.id_oficina)then
                            update gr09_cliente set cantidad_salas = cantidad_salas + 1 where nro_doc = mifila.nro_doc;
                            update gr09_cliente set cantidad_salas = cantidad_salas - 1 where nro_doc = mifilavieja.nro_doc;
                        else
                            if(mifila.nro_doc = mifilavieja.nro_doc AND mifila.id_oficina != mifilavieja.id_oficina)then
                                if(tipo_alquiler != tipo_alquiler_viejo)then
                                    update gr09_cliente set cantidad_oficinas = cantidad_oficinas - 1 where nro_doc = mifilavieja.nro_doc;
                                    update gr09_cliente set cantidad_salas = cantidad_salas + 1 where nro_doc = mifila.nro_doc;
                                end if;
                            else
                                if(mifila.nro_doc != mifilavieja.nro_doc AND mifila.id_oficina != mifilavieja.id_oficina)then
                                    if(tipo_alquiler != tipo_alquiler_viejo)then
                                        update gr09_cliente set cantidad_oficinas = cantidad_oficinas - 1 where nro_doc = mifilavieja.nro_doc;
                                        update gr09_cliente set cantidad_salas = cantidad_salas + 1 where nro_doc = mifila.nro_doc;
                                    else
                                        update gr09_cliente set cantidad_salas = cantidad_salas + 1 where nro_doc = mifila.nro_doc;
                                        update gr09_cliente set cantidad_salas = cantidad_salas - 1 where nro_doc = mifilavieja.nro_doc;
                                    end if;
                                else
                                    update gr09_cliente set cantidad_salas = cantidad_salas + 1 where nro_doc = mifila.nro_doc;
                                end if;
                            end if;
                        end if;
                    end if;
                end if;
            num := num + 1;
            end loop;
        end if;
        if(TG_OP = 'DELETE')then
            for mifilavieja in select * from old_table
            loop
                if(mifilavieja.fecha_hasta IS NULL )then
                    select tipo_o into tipo_alquiler
                    from gr09_oficina
                    where id_oficina = mifilavieja.id_oficina;
                    if(tipo_alquiler = 'O') then
                        update gr09_cliente set cantidad_oficinas = cantidad_oficinas - 1 where nro_doc = mifilavieja.nro_doc;
                    else
                        update gr09_cliente set cantidad_salas = cantidad_salas - 1 where nro_doc = mifilavieja.nro_doc;
                    end if;
                end if;
            end loop;
        end if;
        return null;
    end;
    $$
language 'plpgsql';

create trigger tr_gr09_registro_alquileres_update after update on gr09_alquila REFERENCING OLD TABLE AS old_table
    NEW TABLE AS new_table for each statement execute procedure fn_gr09_actualizar_registros_oficinas();

create trigger tr_gr09_registro_alquileres_insert after insert on gr09_alquila REFERENCING NEW TABLE AS new_table
    for each statement  execute procedure fn_gr09_actualizar_registros_oficinas();

create trigger tr_gr09_registro_alquileres_delete after delete on gr09_alquila REFERENCING OLD TABLE AS old_table
    for each statement execute procedure fn_gr09_actualizar_registros_oficinas();

/*A. TRIGGERS Y SERVICIOS
2. Utilizando 2 vistas V_OFICINA_REGULAR y V_SALA_CONVENCION que contienen todos
los datos de las oficinas regulares o de las salas de convención respectivamente, construir
los triggers INSTEAD OF necesarios para mantener actualizadas las tablas de OFICINA,
OFICINA_REG y SALA_CONVENSION de manera de respetar el diseño de datos de la
jerarquía.*/

CREATE VIEW GR09_V_OFICINA_REGULAR AS
SELECT o.id_oficina, o.superficie, o.cant_max_personas, o.monto_alquiler, r.cant_escritorios, r.cant_pc
FROM gr09_oficina o NATURAL JOIN gr09_oficina_reg r;

CREATE VIEW GR09_V_SALA_CONVENCION AS
SELECT o.id_oficina, o.superficie, o.cant_max_personas, o.monto_alquiler, sv.cant_pantallas, sv.cant_sillas
FROM gr09_oficina o  NATURAL JOIN gr09_sala_convencion sv;

CREATE OR REPLACE FUNCTION fn_gr09_oficina_regular()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'UPDATE') THEN
        UPDATE gr09_oficina SET superficie = new.superficie, cant_max_personas = new.cant_max_personas, monto_alquiler = new.monto_alquiler
        WHERE id_oficina = new.id_oficina;
        UPDATE gr09_oficina_reg SET cant_escritorios = new.cant_escritorios, cant_pc = new.cant_pc
        WHERE id_oficina = new.id_oficina;
    ELSE
        INSERT INTO gr09_oficina (id_oficina, superficie, cant_max_personas, monto_alquiler, tipo_o)
        VALUES (new.id_oficina, new.superficie, new.cant_max_personas, new.monto_alquiler, 'O');
        INSERT INTO gr09_oficina_reg (id_oficina, cant_escritorios, cant_pc) VALUES (new.id_oficina, new.cant_escritorios, new.cant_pc);
    END IF;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_gr09_oficina_regular
INSTEAD OF INSERT OR UPDATE ON GR09_V_OFICINA_REGULAR
FOR EACH ROW EXECUTE PROCEDURE fn_gr09_oficina_regular();

CREATE OR REPLACE FUNCTION fn_gr09_sala_convencion()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'UPDATE') THEN
        UPDATE gr09_oficina SET superficie = new.superficie, cant_max_personas = new.cant_max_personas, monto_alquiler = new.monto_alquiler
        WHERE id_oficina = new.id_oficina;
        UPDATE gr09_sala_convencion SET cant_pantallas = new.cant_pantallas, cant_sillas = new.cant_sillas
        WHERE id_oficina = new.id_oficina;
    ELSE
        INSERT INTO gr09_oficina (id_oficina, superficie, cant_max_personas, monto_alquiler, tipo_o)
        VALUES (new.id_oficina, new.superficie, new.cant_max_personas, new.monto_alquiler, 'S');
        INSERT INTO gr09_sala_convencion (id_oficina, cant_pantallas, cant_sillas) VALUES (new.id_oficina, new.cant_pantallas, new.cant_sillas);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_gr09_sala_convencion
INSTEAD OF INSERT OR UPDATE ON GR09_V_SALA_CONVENCION
FOR EACH ROW EXECUTE PROCEDURE fn_gr09_sala_convencion();

/*B. VISTAS
1. Construya una vista V_CLIENTES_COMP que contenga las oficinas que han sido alquiladas
por todos los clientes.*/
CREATE VIEW GR09_V_CLIENTES_COMP AS
    SELECT * FROM gr09_oficina
    WHERE id_oficina IN (
        SELECT id_oficina
        FROM gr09_alquila
        GROUP BY id_oficina
        having COUNT(*) >= (SELECT count(*) FROM gr09_cliente));

/*B. VISTAS
2. Construya una vista V_OFICINAS_REG que liste para cada oficina su identificador, su tipo,
su superficie, su monto de alquiler y la cantidad promedio de escritorios por superficie.*/
CREATE VIEW GR09_V_OFICINAS_REG AS
    SELECT o.id_oficina, tipo_o, superficie, monto_alquiler, cant_escritorios/superficie as promedio_escritorio
    FROM gr09_oficina o NATURAL JOIN gr09_oficina_reg;

