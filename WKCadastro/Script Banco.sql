CREATE TABLE IF NOT EXISTS public.pessoa(
    idpessoa bigserial NOT NULL,
    flnatureza int2 NOT NULL,
    dsdocumento varchar(20) NOT NULL,
    nmprimeiro varchar(100) NOT NULL,
    nmsegundo varchar(100) NOT NULL,
    dtregistro date null,
    CONSTRAINT pessoa_pkey PRIMARY KEY (idpessoa)
);

CREATE TABLE IF NOT EXISTS public.endereco(
    idendereco bigserial NOT NULL,
    idpessoa int8 NOT NULL,
    dscep varchar(15) NULL,
    CONSTRAINT endereco_pkey PRIMARY KEY (idendereco),
    CONSTRAINT endereco_fkey FOREIGN KEY (idpessoa) REFERENCES pessoa(idpessoa) ON DELETE CASCADE
);

CREATE INDEX endereco_idpessoa ON endereco(idpessoa);

CREATE TABLE endereco_integracao (
    idendereco bigint NOT NULL,
	dsuf varchar(50) NULL,
	nmcidade varchar(100) NULL,
	nmbairro varchar(50) NULL,
	nmlogradouro varchar(100) NULL,
	dscomplemento varchar(100) NULL,
    CONSTRAINT enderecointegracao_pkey PRIMARY KEY (idendereco),
    CONSTRAINT enderecointegracao_fkey_endereco FOREIGN KEY (idendereco) REFERENCES endereco(idendereco) ON DELETE CASCADE
);	
	


