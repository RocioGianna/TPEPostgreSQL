-- tables
-- Table: ALQUILA
CREATE TABLE GR09_ALQUILA (
    tipo_doc char(3)  NOT NULL,
    nro_doc int  NOT NULL,
    id_oficina int  NOT NULL,
    fecha_desde date  NOT NULL,
    fecha_hasta date  NULL,
    CONSTRAINT PK_GR09_ALQUILA PRIMARY KEY (tipo_doc,nro_doc,id_oficina)
);

-- Table: CLIENTE
CREATE TABLE GR09_CLIENTE (
    tipo_doc char(3)  NOT NULL,
    nro_doc int  NOT NULL,
    nombre varchar(50)  NOT NULL,
    apellido varchar(50)  NOT NULL,
    e_mail varchar(50)  NOT NULL,
    cantidad_oficinas int default 0 ,
    cantidad_salas int default 0 ,
    CONSTRAINT PK_GR09_CLIENTE PRIMARY KEY (tipo_doc,nro_doc)
);

-- Table: OFICINA
CREATE TABLE GR09_OFICINA (
    id_oficina int  NOT NULL,
    superficie int  NOT NULL,
    cant_max_personas int  NOT NULL,
    monto_alquiler decimal(10,2)  NOT NULL,
    tipo_o char(1)  NOT NULL,
    CONSTRAINT PK_GR09_OFICINA PRIMARY KEY (id_oficina)
);

-- Table: OFICINA_REG
CREATE TABLE GR09_OFICINA_REG (
    id_oficina int  NOT NULL,
    cant_escritorios int  NOT NULL,
    cant_pc int  NOT NULL,
    CONSTRAINT PK_GR09_OFICINA_REG PRIMARY KEY (id_oficina)
);

-- Table: SALA_CONVENCION
CREATE TABLE GR09_SALA_CONVENCION (
    id_oficina int  NOT NULL,
    cant_sillas int  NOT NULL,
    cant_pantallas int  NOT NULL,
    CONSTRAINT PK_GR09_SALA_CONVENCION PRIMARY KEY (id_oficina)
);

-- foreign keys
-- Reference: FK_ALQUILA_CLIENTE (table: ALQUILA)
ALTER TABLE GR09_ALQUILA ADD CONSTRAINT FK_GR09_ALQUILA_CLIENTE
    FOREIGN KEY (tipo_doc, nro_doc)
    REFERENCES GR09_CLIENTE (tipo_doc, nro_doc)
    ON DELETE CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_ALQUILA_OFICINA (table: ALQUILA)
ALTER TABLE GR09_ALQUILA ADD CONSTRAINT FK_GR09_ALQUILA_OFICINA
    FOREIGN KEY (id_oficina)
    REFERENCES GR09_OFICINA (id_oficina)
    ON DELETE CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_OFICINA_REG_OFICINA (table: OFICINA_REG)
ALTER TABLE GR09_OFICINA_REG ADD CONSTRAINT FK_GR09_OFICINA_REG_OFICINA
    FOREIGN KEY (id_oficina)
    REFERENCES GR09_OFICINA (id_oficina)
    ON DELETE CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- Reference: FK_SALA_CONVENCION_OFICINA (table: SALA_CONVENCION)
ALTER TABLE GR09_SALA_CONVENCION ADD CONSTRAINT FK_GR09_SALA_CONVENCION_OFICINA
    FOREIGN KEY (id_oficina)
    REFERENCES GR09_OFICINA (id_oficina)
    ON DELETE CASCADE
    NOT DEFERRABLE
    INITIALLY IMMEDIATE
;

-- End of file.

