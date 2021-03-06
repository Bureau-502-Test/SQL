-- Création de la struture pour intégrer les données IRIS.
-- 1. Création de la table TA_IRIS qui recense les zones IRIS

-- 1.1. Création de la table
CREATE TABLE TA_IRIS(
	objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY START WITH 1 INCREMENT BY 1,
	fid_code NUMBER(38,0),
	fid_nom NUMBER(38,0),
	fid_libelle_court NUMBER(38,0),
	fid_metadonnee NUMBER(38,0),
	fid_iris_geom NUMBER(38,0)
	);

-- 1.2 Création des commentaires des colonnes

COMMENT ON TABLE g_geo.ta_iris IS 'Table regroupant les zones IRIS';
COMMENT ON COLUMN g_geo.ta_iris.objectid IS 'Clé primaire de la table TA_BPE.';
COMMENT ON COLUMN g_geo.ta_iris.fid_code IS 'Clé étrangère vers la table TA_CODE pour connaitre le code de la zone IRIS.';
COMMENT ON COLUMN g_geo.ta_iris.fid_nom IS 'Clé étrangère vers la table TA_NOM pour connaitre le nom de la zone IRIS.';
COMMENT ON COLUMN g_geo.ta_iris.fid_libelle_court IS 'Clé étrangère vers la table TA_LIBELLE_COURT pour connaitre le type de zone IRIS.';
COMMENT ON COLUMN g_geo.ta_iris.fid_metadonnee IS 'Clé étrangère vers la table TA_METADONNE pour connaitre la source et le millesime de la zone IRIS.';
COMMENT ON COLUMN g_geo.ta_iris.fid_iris_geom IS 'Clé étrangère vers la table TA_IRIS_GEOM pour connaitre la géométrie de la zone IRIS.';

-- 1.3 Création de la clé primaire
ALTER TABLE ta_iris
	ADD CONSTRAINT ta_iris_PK 
	PRIMARY KEY("OBJECTID")
	USING INDEX TABLESPACE "G_ADT_INDX";


-- 1.4 Création des clés étrangères

-- 1.4.1 vers la table ta_code
ALTER TABLE ta_iris
	ADD CONSTRAINT ta_iris_fid_code_FK 
	FOREIGN KEY (fid_code)
	REFERENCES ta_code(objectid);

-- 1.4.2 vers la table ta_nom
ALTER TABLE ta_iris
	ADD CONSTRAINT ta_iris_fid_nom_FK 
	FOREIGN KEY (fid_nom)
	REFERENCES ta_nom(objectid);

-- 1.4.3 vers la table ta_libelle
ALTER TABLE ta_iris
	ADD CONSTRAINT ta_iris_fid_libelle_court_FK 
	FOREIGN KEY (fid_libelle_court)
	REFERENCES ta_libelle_court(objectid);

-- 1.4.4 vers la table ta_metadonnee
ALTER TABLE ta_iris
	ADD CONSTRAINT ta_iris_fid_metadonnee_FK 
	FOREIGN KEY (fid_metadonnee)
	REFERENCES ta_metadonnee(objectid);

-- 1.4.5 vers la table ta_iris_geom
ALTER TABLE ta_iris
	ADD CONSTRAINT ta_iris_fid_iris_geom_FK 
	FOREIGN KEY (fid_iris_geom)
	REFERENCES ta_iris_geom(objectid);


-- 1.5 Création des index sur les cléfs étrangères.
CREATE INDEX ta_iris_fid_code_IDX ON ta_iris(fid_code)
TABLESPACE G_ADT_INDX;

CREATE INDEX ta_iris_fid_nom_IDX ON ta_iris(fid_nom)
TABLESPACE G_ADT_INDX;

CREATE INDEX ta_iris_fid_libelle_court_IDX ON ta_iris(fid_libelle_court)
TABLESPACE G_ADT_INDX;

CREATE INDEX ta_iris_fid_metadonnee_IDX ON ta_iris(fid_metadonnee)
TABLESPACE G_ADT_INDX;

CREATE INDEX ta_iris_fid_iris_geom_IDX ON ta_iris(fid_iris_geom)
TABLESPACE G_ADT_INDX;



-- 2. Creation de la table TA_IRIS_GEOM qui recense les zones IRIS.

-- 2.1 Création de la table
CREATE TABLE TA_IRIS_GEOM(
	objectid NUMBER(38,0) GENERATED ALWAYS AS IDENTITY START WITH 1 INCREMENT BY 1,
	geom SDO_GEOMETRY
	);

-- 2.2 Création des commentaires des colonnes

COMMENT ON TABLE g_geo.TA_IRIS_GEOM IS 'Table regroupant les zones IRIS';
COMMENT ON COLUMN g_geo.TA_IRIS_GEOM.objectid IS 'Clé primaire de la table TA_BPE.';
COMMENT ON COLUMN g_geo.TA_IRIS_GEOM.geom IS 'Géométrie de la zone IRIS.';

-- 2.3 Création de la clé primaire
ALTER TABLE TA_IRIS_GEOM
	ADD CONSTRAINT TA_IRIS_GEOM_PK 
	PRIMARY KEY("OBJECTID")
	USING INDEX TABLESPACE "G_ADT_INDX";


-- 2.4 Création des métadonnées spatiales
INSERT INTO USER_SDO_GEOM_METADATA(
    TABLE_NAME, 
    COLUMN_NAME, 
    DIMINFO, 
    SRID
)
VALUES(
    'ta_iris_geom',
    'geom',
    SDO_DIM_ARRAY(SDO_DIM_ELEMENT('X', 594000, 964000, 0.005),SDO_DIM_ELEMENT('Y', 6987000, 7165000, 0.005)), 
    2154
);

-- 2.5 Création de l'index spatial sur le champ geom
CREATE INDEX ta_iris_geom_SIDX
ON ta_iris_geom(GEOM)
INDEXTYPE IS MDSYS.SPATIAL_INDEX
PARAMETERS('sdo_indx_dims=2, layer_gtype=MULTIPOLYGON, tablespace=G_ADT_INDX, work_tablespace=DATA_TEMP');
