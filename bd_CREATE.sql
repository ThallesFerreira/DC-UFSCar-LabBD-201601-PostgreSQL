---------------------
----- SEQUENCES -----
---------------------
CREATE SEQUENCE atcomp_codigo_seq
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 1000
    START WITH 1
    NO CYCLE
    CACHE 1;

---------------------
------- TIPOS -------
---------------------

CREATE TYPE telefone AS 
(
    origem character varying(20),
    tipo character varying(20),
    ramal integer,
    ddd integer,
    fone bigint 
);

CREATE TYPE coord AS 
(
    nome character varying(40),
    telefone telefone
);

CREATE TYPE endereco AS 
(
    rua character varying(50),
    complemento character varying(20),
    bairro character varying(20),
    cidade character varying(20),
    uf character varying(2),
    pais character varying(20),
    cep bigint 
);

CREATE TYPE gradecurricular AS 
(
	Optativa boolean,
	Obrigatoria boolean,
	Eletiva boolean
);

CREATE TYPE supervisor AS 
(
    cpf bigint,
    nome character varying(30)
);





---------------------
----- ENTIDADES -----
---------------------

-- ATIVIDADE COMPLEMENTAR
CREATE TABLE AtComp
(
	"codigo" integer NOT NULL DEFAULT nextval('"atcomp_codigo_seq"'::regclass),
  	creditos integer NOT NULL,
  	nome character varying(100),

  	CONSTRAINT AtComp_PK PRIMARY KEY (codigo)
);

-- CAMPUS
CREATE TABLE Campus
(
	nome character varying(50),
	website character varying(100),
 	sigla character varying(10) NOT NULL,
  	telefone1 character varying(20) NOT NULL,
 	telefone2 character varying(20),
 	endereco character varying(100) NOT NULL,

 	CONSTRAINT Campus_PK PRIMARY KEY (sigla)
);
 
-- CENTRO
CREATE TABLE Centro
(
  	nome character varying(50),
  	website character varying(100),
  	geo character varying(50),
  	sigla character varying(10) NOT NULL,
  	telefone1 character varying(20) NOT NULL,
  	telefone2 character varying(20),

  	CONSTRAINT Centro_PK PRIMARY KEY (sigla)
);

-- CURSO
CREATE TABLE Curso 
(
    codigo integer NOT NULL,
    website character varying(40),
    nome character varying(40),
    coordenador coord,

    CONSTRAINT Curso_PK PRIMARY KEY (codigo)
);

-- RECONHECIMENTO DE CURSO
CREATE TABLE ReconhecimentoDeCurso 
(
	codigoR character varying(10) not null,
	codigo integer,

	CONSTRAINT  ReconhecimentoDeCurso_fk FOREIGN KEY(codigo) REFERENCES Curso(codigo),
	CONSTRAINT ReconhecimentoDeCurso_pk PRIMARY KEY (codigo,codigoR)
);


-- DISCIPLINA
CREATE TABLE Disciplina 
(
	codigo character varying(10) CONSTRAINT Disciplina_PK PRIMARY KEY,
	nome character varying(50),
	nro_creditos integer,
	categoria character varying(20)	
);

-- EMPRESA
CREATE TABLE Empresa 
(
    cnpj bigint CONSTRAINT Empresa_PK PRIMARY KEY,
    nome character varying(20),
    endereco endereco
);

-- PESSOA
CREATE TABLE Pessoa 
(
	rg character varying(9) NOT NULL,
	pre_nome character varying(20),
	meio_nome character varying(20),
	ultimo_nome character varying(20),
	email character varying(20),
	email_institucional character varying(20),
	etnia character varying(15),
	sexo char,
	data_nascimento date,
	nome_mae character varying(20),
	nome_pai character varying(20),
	origem_cidade character varying(20),
	origem_estado character varying(20),
	origem_pais character varying(20),
	nacionalidade character varying(15),
  
	CONSTRAINT Pessoa_PK PRIMARY KEY (rg)
);

-- ENDEREÇO DE PESSOA
CREATE TABLE PessoaEndereco
(
	Pessoa_rg  character varying(9) NOT NULL,
    rua character varying(15) NOT NULL,
    num_casa integer NOT NULL,
    complemento character varying(15),
    bairro character varying(15),
    uf character varying(2),
    cep integer,

    CONSTRAINT PessoaEndereco_Pessoa_FK FOREIGN KEY (Pessoa_rg) REFERENCES Pessoa (rg) ON DELETE CASCADE,
    CONSTRAINT PessoaEndereco_PK PRIMARY KEY (Pessoa_rg, num_casa, cep)
);

-- TELEFONE DE PESSOA
CREATE TABLE PessoaTelefone
(
	Pessoa_rg character varying(9) NOT NULL,
    ddd integer NOT NULL, 
    numero integer NOT NULL,
    tipo character varying(6) NOT NULL,
    ramal integer NOT NULL,
    
    CONSTRAINT PessoaTelefone_Pessoa_FK FOREIGN KEY (Pessoa_rg) REFERENCES Pessoa (rg) ON DELETE CASCADE,
 	CONSTRAINT PessoaTelefone_PK PRIMARY KEY (Pessoa_rg, ddd, numero, ramal, tipo)
);

-- CONSELHO DE CURSO
CREATE TABLE ConselhoCurso
(  
	
	Pessoa_rg character varying(9),
	id integer not null,

	CONSTRAINT ConselhoCurso_Pessoa_fk FOREIGN KEY (Pessoa_rg) REFERENCES Pessoa(rg),
	CONSTRAINT ConselhoCurso_pk PRIMARY KEY (id) 
);

-- NUCLEO DOCENTE
CREATE TABLE NucleoDocente
(  
	presidente character varying(20),
	codigo integer NOT NULL,

	CONSTRAINT NucleoDocente_PK PRIMARY KEY (codigo) 
);

-- ESTUDANTE
CREATE TABLE Estudante 
(
	Pessoa_rg character varying (9) NOT NULL,
	ra integer NOT NULL UNIQUE,
	ira integer NOT NULL,
	anoConcEM character varying(4),
	presencial char, -- atributo descriminatório: Presencial(s) ou Distancia(n) (7.2.1 - C Elmasri)
	graduando boolean, -- Flag de reconhecimento Estudante Graduando
	posGraduando boolean, -- Flag de reconhecimento Estudante Pós Graduando(7.2.1 - D Elmasri)

	CONSTRAINT Estudante_Pessoa_FK FOREIGN KEY (Pessoa_rg) REFERENCES Pessoa (rg) ON DELETE CASCADE,
	CONSTRAINT Estudante_PK PRIMARY KEY (Pessoa_rg, ra)
);

-- REUNIÃO
CREATE TABLE Reuniao 
(
	numero integer NOT NULL UNIQUE,
	pauta text,
	dataInicio date,

	CONSTRAINT Reuniao_PK PRIMARY KEY (numero)
);

-- CALENDÁRIO
CREATE TABLE Calendario 
(
	dataInicio date NOT NULL,
	dataFim date,
	diasLetivos integer NOT NULL,
	tipo char NOT NULL, -- atributo discriminatório Graduação Presencial (p), EaD (e) ou Administrativo (a)
	aprovado boolean DEFAULT FALSE,
	Reuniao_numero integer,

	CONSTRAINT Calendario_Reuniao_FK FOREIGN KEY (Reuniao_numero) REFERENCES Reuniao(numero)
		ON DELETE RESTRICT,
	CONSTRAINT Calendario_PK PRIMARY KEY (dataInicio, tipo)
);

-- EVENTO
CREATE TABLE Evento 
(
	id serial NOT NULL UNIQUE,
	dataInicio date NOT NULL,
	dataFim date,
	descricao text,
	Calendario_data date NOT NULL, -- data de início do calendario ao qual o evento pertence
	Calendario_tipo char, -- tipo do calendario ao qual o eento pertence

	CONSTRAINT Evento_Calendario_FK FOREIGN KEY (Calendario_data, Calendario_tipo) REFERENCES Calendario(dataInicio, tipo)
		ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT Evento_PK PRIMARY KEY (Calendario_data, Calendario_tipo, id)
);

-- ATIVIDADE
CREATE TABLE Atividade
(
 	dataInicio date NOT NULL,
 	dataFim date,
 	atributo char, -- atributo descriminatório sobre tipo de atividade
 	Calendario_dataInicio date NOT NULL,
 	Calendario_tipo char DEFAULT 'a',

 	CONSTRAINT Atividade_Calendario_FK FOREIGN KEY (Calendario_dataInicio, Calendario_tipo) REFERENCES Calendario (dataInicio, tipo) ON DELETE CASCADE,
 	CONSTRAINT Atividade_PK PRIMARY KEY (dataInicio)
);

-- DOCENTE
CREATE TABLE Docente 
(
    Pessoa_rg character varying(9) NOT NULL,
    codigo integer NOT NULL UNIQUE,

    CONSTRAINT Docente_Pessoa_FK FOREIGN KEY (Pessoa_rg) REFERENCES Pessoa (rg) ON DELETE CASCADE,
    CONSTRAINT Docente_PK PRIMARY KEY (Pessoa_rg, codigo)
);

-- FASE
CREATE TABLE Fase 
(
	comite_avaliador character varying(400),
	itens character varying(400),
	id character varying(10) not null,
	tipo INTEGER,
	documentos character varying(400),
	periodo date,
	ReconhecimentoDeCurso_codigo character varying(10), 
	curso_codigo INTEGER,


	CONSTRAINT Fase_pk PRIMARY KEY (id,curso_codigo,ReconhecimentoDeCurso_codigo),
	CONSTRAINT Fase_ReconhecimentoDeCurso_fk FOREIGN KEY (ReconhecimentoDeCurso_codigo,curso_codigo) REFERENCES ReconhecimentoDeCurso (codigoR,codigo) 
	on update cascade
);

-- TÉCNICO ADMINISTRATIVO
CREATE TABLE TecAdm 
(
    Pessoa_rg character varying(9) NOT NULL,
    codigo integer NOT NULL UNIQUE,

    CONSTRAINT TecAdm_Pessoa_FK FOREIGN KEY (Pessoa_rg) REFERENCES Pessoa (rg) ON DELETE CASCADE, 
    CONSTRAINT TecAdm_PK PRIMARY KEY (Pessoa_rg, codigo)
);

-- PROJETO POLÍTICO-PEDAGÓGICO
CREATE TABLE ProjetoPoliticoPedagogico 
(
	grade gradecurricular,
	ConselhoCurso_id integer NOT NULL, -- Conselho de Curso que define PPP
	Curso_codigo integer, -- Curso que possui PPP

	CONSTRAINT ProjetoPoliticoPedagogico_ConselhoCurso_FK FOREIGN KEY (ConselhoCurso_id) REFERENCES ConselhoCurso (id) ON DELETE CASCADE,
	CONSTRAINT ProjetoPoliticoPedagogico_Curso_FK FOREIGN KEY (Curso_codigo) REFERENCES Curso (codigo) ON DELETE CASCADE,
	CONSTRAINT ProjetoPoliticoPedagogico_PK PRIMARY KEY (ConselhoCurso_id, grade)
);

-- POLO À DISTANCIA
CREATE TABLE PoloDistancia
(
	nome character varying(12) NOT NULL,
	cep character varying(10),
	rua character varying(40),
	complemento character varying(20),
	bairro character varying(20),
	cidade character varying(20),
	uf character varying(2),
	pais character varying(10),
	pontoGeoreferenciado character varying(50),
	coordenador_PreNome character varying(12),
	coordenador_SobreNome character varying (20),
	coordenador_email1 character varying(20),
	coordenador_email2 character varying(20),
	coordenador_telefone1 character varying(20),
	coordenador_telefone2 character varying(20),
	tutor_PreNome character varying(12),
	tutor_SobreNome character varying(20),
	tutor_email1 character varying(20),
	tutor_email2 character varying(20),
	tutor_telefone1 character varying(20),
	tutor_telefone2 character varying(20),

	CONSTRAINT PoloDistancia_PK PRIMARY KEY (nome)
);

-- FOTOS DE UM POLO 
CREATE TABLE PoloDistanciaFoto 
(
	PoloDistancia_nome character varying(12) NOT NULL,
	numero integer NOT NULL,
	imagem character varying(20),

	CONSTRAINT Foto_PoloDistancia_FK FOREIGN KEY (PoloDistancia_nome) REFERENCES PoloDistancia (nome) ON DELETE CASCADE,
	CONSTRAINT PoloDistanciaFoto_PK PRIMARY KEY (PoloDistancia_nome, numero)
);

-- TELEFONES DE UM POLO
CREATE TABLE PoloDistanciaTelefone 
(
	PoloDistancia_nome character varying(12) NOT NULL,
	tipo character varying(10) NOT NULL,
	ddd character varying(3),
	fone character varying(10),
	ramal character varying(5),
	origem character varying(10),

	CONSTRAINT Telefone_PoloDistancia_FK FOREIGN KEY (PoloDistancia_nome) REFERENCES PoloDistancia (nome) ON DELETE CASCADE,
	CONSTRAINT PoloDistanciaTelefone_PK PRIMARY KEY (PoloDistancia_nome, tipo)
);

-- TURMA
CREATE TABLE Turma 
(
 	id char NOT NULL,
 	ano integer NOT NULL,
 	semestre integer NOT NULL,
 	Disciplina_codigo character varying(10) NOT NULL,
 	Docente_codigo integer,
 	vagas integer,

 	CONSTRAINT Turma_Disciplina_FK FOREIGN KEY (Disciplina_codigo) REFERENCES Disciplina (codigo) ON DELETE CASCADE,
 	CONSTRAINT Turma_Docente_FK FOREIGN KEY (Docente_codigo) REFERENCES Docente (codigo) ON DELETE CASCADE,
 	CONSTRAINT Turma_PK PRIMARY KEY (Disciplina_codigo, id, ano, semestre)
);

-- SALA
CREATE TABLE Sala 
(
	codigo character varying(20) NOT NULL,
 	Turma_id char NOT NULL,
 	Turma_ano integer NOT NULL,
 	Turma_semestre integer NOT NULL,
 	Turma_Disciplina_codigo character varying(10) NOT NULL,

 	CONSTRAINT Sala_Turma_FK FOREIGN KEY (Turma_Disciplina_codigo, Turma_id, Turma_ano, Turma_semestre ) REFERENCES Turma (Disciplina_codigo, id, ano, semestre) ON DELETE CASCADE,
 	CONSTRAINT Sala_PK PRIMARY KEY (Turma_Disciplina_codigo, Turma_id, Turma_ano, Turma_semestre, codigo)
);

-- DEPARTAMENTO
CREATE TABLE Departamento
(
  	nome character varying(50),
  	website character varying(100),
  	sigla character varying(10) NOT NULL,
  	telefone1 character varying(20) NOT NULL,
  	telefone2 character varying(20),
  	endereco character varying (100) NOT NULL,
  	Campus_sigla character varying(10),

  	CONSTRAINT Departamento_PK PRIMARY KEY (sigla),
  	CONSTRAINT Departamento_Campus_FK FOREIGN KEY (Campus_sigla) REFERENCES Campus (sigla) ON DELETE CASCADE
);


---------------------
-- RELACIONAMENTOS --
---------------------

-- Possui (Conselho_Curso x Nucleo_Docente)
CREATE TABLE PossuiCCND
(
	ConselhoCurso_id integer NOT NULL,
	NucleoDocente_codigo integer NOT NULL,

	CONSTRAINT PossuiCCND_PK PRIMARY KEY (ConselhoCurso_id, NucleoDocente_codigo),
	CONSTRAINT PossuiCCND_ConselhoCurso_FK FOREIGN KEY (ConselhoCurso_id) REFERENCES ConselhoCurso (id) ON DELETE CASCADE,
	CONSTRAINT PossuiCCND_NucleoDocente_FK FOREIGN KEY (NucleoDocente_codigo) REFERENCES NucleoDocente (codigo) ON DELETE CASCADE 
);

-- Pertence (ConselhoCurso x Pessoa)
CREATE TABLE PertenceCCP 
( 
	categoria character varying(20), 
	periodo date,
	Pessoa_rg character varying(9) ,
	ConselhoCurso_id integer not null,

	CONSTRAINT PertenceCP_Pessoa_fk FOREIGN KEY (Pessoa_rg) REFERENCES Pessoa (rg),
	CONSTRAINT PertenceCP_ConselhoCurso_fk FOREIGN KEY (ConselhoCurso_id) REFERENCES ConselhoCurso (id),
	CONSTRAINT pertence_PK PRIMARY KEY(Pessoa_rg, ConselhoCurso_id)
);

-- Pertence (Disciplina x Departamento)
CREATE TABLE PertenceDD 
(
	Departamento_sigla character varying(100) NOT NULL,
	Disciplina_codigo character varying(10) NOT NULL,

	CONSTRAINT PertenceDD_Departamento_FK FOREIGN KEY (Departamento_sigla) REFERENCES Departamento (sigla) ON DELETE CASCADE,
	CONSTRAINT PertenceDD_Disciplina_FK FOREIGN KEY (Disciplina_codigo) REFERENCES Disciplina (codigo) ON DELETE CASCADE,
	CONSTRAINT PertenceDD_PK PRIMARY KEY (Departamento_sigla, Disciplina_codigo)
);

-- Pertence (Docente x NucleoDocente)
CREATE TABLE PertenceDND
(
    Docente_Pessoa_rg character varying(9) NOT NULL,
    NucleoDocente_codigo integer NOT NULL,
    Docente_codigo integer NOT NULL,
    periodo timestamp, 

    CONSTRAINT PertenceDND_Docente_FK FOREIGN KEY (Docente_Pessoa_rg, Docente_codigo) REFERENCES Docente (Pessoa_rg, codigo) ON DELETE CASCADE,
    CONSTRAINT PertenceDND_NucleoDocente_FK FOREIGN KEY (NucleoDocente_codigo) REFERENCES NucleoDocente (codigo) ON DELETE CASCADE,    
    CONSTRAINT PertenceDND_PK PRIMARY KEY (Docente_Pessoa_rg, Docente_codigo, NucleoDocente_codigo, periodo)
);

-- Pertence (Estudante x PoloDistancia)
CREATE TABLE PertenceEPD
(
	Estudante_ra integer NOT NULL,
	Estudante_Pessoa_rg character varying (9) NOT NULL,
	PoloDistancia_nome character varying(12) NOT NULL,

	CONSTRAINT PertenceEPD_Estudante_FK FOREIGN KEY (Estudante_Pessoa_rg, Estudante_ra) REFERENCES Estudante (Pessoa_rg, ra) ON DELETE CASCADE,
	CONSTRAINT PertenceEPD_PoloDistancia_FK FOREIGN KEY (PoloDistancia_nome) REFERENCES PoloDistancia (nome) ON DELETE CASCADE,
	CONSTRAINT PertenceEPD_PK PRIMARY KEY (Estudante_Pessoa_rg, Estudante_ra, PoloDistancia_nome)
);

-- Realiza (AtComp x Estudante)
CREATE TABLE RealizaACE
(
	Estudante_Pessoa_rg character varying (9) NOT NULL,
  	Estudante_ra integer NOT NULL,
  	AtComp_codigo integer NOT NULL,
  	nrosemestres integer DEFAULT 1,
 
  	CONSTRAINT RealizaACE_Estudante_FK FOREIGN KEY (Estudante_Pessoa_rg, Estudante_ra) REFERENCES Estudante (Pessoa_rg, ra) ON DELETE CASCADE,
  	CONSTRAINT RealizaACE_AtComp_FK FOREIGN KEY (AtComp_codigo) REFERENCES AtComp (codigo) ON DELETE CASCADE,
  	CONSTRAINT RealizaACE_PK PRIMARY KEY (Estudante_Pessoa_rg, Estudante_ra, AtComp_codigo)
);

-- Realiza (ConselhoCurso x Reuniao)
CREATE TABLE RealizaCCRe
(
	ConselhoCurso_id integer NOT NULL,
	Reuniao_numero integer NOT NULL,

	CONSTRAINT RealizaCCRe_ConselhoCurso_FK FOREIGN KEY (ConselhoCurso_id) REFERENCES ConselhoCurso (id) ON DELETE CASCADE,
	CONSTRAINT RealizaCCRe_Reuniao_FK FOREIGN KEY (Reuniao_numero) REFERENCES Reuniao (numero) ON DELETE CASCADE,
	CONSTRAINT RealizaCCRe_PK PRIMARY KEY (ConselhoCurso_id, Reuniao_numero) 
);

-- Compoe (Disciplina x Curso)
CREATE TABLE Compoe
(
	Disciplina_codigo character varying(10) NOT NULL,
	Curso_codigo integer NOT NULL,
	obrigatoriedade boolean,
	perfil char, -- atributo descriminatório sobre perfil

	CONSTRAINT Compoe_Disciplina_FK FOREIGN KEY (Disciplina_codigo) REFERENCES Disciplina (codigo) ON DELETE CASCADE,
	CONSTRAINT Compoe_Curso_FK FOREIGN KEY (Curso_codigo) REFERENCES Curso (codigo) ON DELETE CASCADE,
	CONSTRAINT Compoe_PK PRIMARY KEY (Disciplina_codigo, Curso_codigo)
);

-- Cursa (Estudante x Turma)
CREATE TABLE Cursa
(
	Estudante_Pessoa_rg character varying (9) NOT NULL,
	Estudante_ra integer NOT NULL,
	Turma_Disciplina_codigo character varying(10) NOT NULL,
	Turma_id char NOT NULL,
	Turma_ano integer NOT NULL,
	Turma_semestre integer NOT NULL,
	media numeric(4,2),
	frequencia numeric(4,2),
	status char, -- "c" cancelado, "t" trancado, "r" reprovado, "a" aprovado

	CONSTRAINT Cursa_Estudante_FK FOREIGN KEY (Estudante_Pessoa_rg, Estudante_ra) REFERENCES Estudante (Pessoa_rg, ra) ON DELETE CASCADE,
	CONSTRAINT Cursa_Turma_FK FOREIGN KEY (Turma_Disciplina_codigo, Turma_ano, Turma_semestre, Turma_id) REFERENCES Turma (Disciplina_codigo, ano, semestre, id) ON DELETE CASCADE,
	CONSTRAINT Cursa_PK PRIMARY KEY (Estudante_Pessoa_rg, Estudante_ra, Turma_ano, Turma_semestre, Turma_id) 
);

-- Disciplina Pré-Requisito (Disciplina x Disciplina)
CREATE TABLE DisciplinaPreReq
(
	Disciplina_codigo character varying(10) NOT NULL,
	PreRequisito_codigo character varying (10) NOT NULL,

	CONSTRAINT Disciplina_FK FOREIGN KEY (Disciplina_codigo) REFERENCES Disciplina (codigo) ON DELETE CASCADE,
	CONSTRAINT PreReq_FK FOREIGN KEY (PreRequisito_codigo) REFERENCES Disciplina(codigo) ON DELETE CASCADE,
	CONSTRAINT DisciplinaPreReq_PK PRIMARY KEY (Disciplina_codigo, PreRequisito_codigo)
);

-- Efetua (NucleoDocente x Reuniao)
CREATE TABLE Efetua
(
	NucleoDocente_codigo integer NOT NULL,
	Reuniao_numero integer NOT NULL,

	CONSTRAINT Efetua_NucleoDocente_FK FOREIGN KEY (NucleoDocente_codigo) REFERENCES NucleoDocente (codigo) ON DELETE CASCADE,
	CONSTRAINT Efetua_Reuniao_FK FOREIGN KEY (Reuniao_numero) REFERENCES Reuniao (numero) ON DELETE CASCADE,
	CONSTRAINT Efetua_PK PRIMARY KEY (NucleoDocente_codigo, Reuniao_numero)
);

-- Estagia (Estudante x Empresa)
CREATE TABLE Estagia 
(
	Estudante_ra integer NOT NULL,
    Empresa_cnpj bigint NOT NULL,
    dataInicio date,
    dataTermino date,
    supEmpresa supervisor,
    supUniversidade supervisor,
    cartaAvaliacao text,
    termoCompromisso text,

    CONSTRAINT Estagia_Empresa_FK FOREIGN KEY (Empresa_cnpj) REFERENCES Empresa (cnpj) ON DELETE CASCADE,
    CONSTRAINT Estagia_Estudante_FK FOREIGN KEY (Estudante_ra) REFERENCES Estudante (ra) ON DELETE CASCADE,
    CONSTRAINT Estagia_PK PRIMARY KEY (Estudante_ra, Empresa_cnpj)
);

--Inscreve (Estudante x Turma)
CREATE TABLE Inscreve
(
	periodo date,
	deferimento boolean,
	prioridade_inscricao integer,
	Turma_ano integer NOT NULL,
	Turma_semestre integer NOT NULL,
	Turma_id char NOT NULL,
	Turma_Disciplina_codigo character varying(10) NOT NULL,
	Estudante_ra integer NOT NULL,

	CONSTRAINT Inscreve_PK PRIMARY KEY (Estudante_ra, Turma_id),
	CONSTRAINT Inscreve_Estudante_FK FOREIGN KEY (Estudante_ra) REFERENCES Estudante (ra) ON DELETE CASCADE,
	CONSTRAINT Inscreve_Turma_FK FOREIGN KEY (Turma_Disciplina_codigo, Turma_ano, Turma_semestre, Turma_id) REFERENCES Turma (Disciplina_codigo, ano, semestre, id) ON DELETE CASCADE
);

-- Matriculado (Estudante x Curso)
CREATE TABLE Matriculado
(
	Estudante_ra integer NOT NULL,
	Curso_codigo integer NOT NULL,
	grade character varying(15), 
	periodo char, -- atributo descriminatório sobre periodo
	status boolean,
	perfil char, -- atributo descriminatório sobre perfil
	ano_ingresso date,
	ano_termino date,

	CONSTRAINT Matriculado_Estudante_FK FOREIGN KEY (Estudante_ra) REFERENCES Estudante (ra) ON DELETE CASCADE,
	CONSTRAINT Matriculado_Curso_FK FOREIGN KEY (Curso_codigo) REFERENCES Curso (codigo) ON DELETE CASCADE,
	CONSTRAINT Matriculado_PK PRIMARY KEY (Estudante_ra, Curso_codigo)
);

-- EhAnterior (Calendario (Anterior) x Calendario (Posterior))
CREATE TABLE EhAnterior
(
	Anterior_dataInicio date NOT NULL,
	Anterior_tipo char NOT NULL,
	Posterior_dataInicio date NOT NULL,
	Posterior_tipo char NOT NULL,

	CONSTRAINT Calendario_Anterior_FK FOREIGN KEY (Anterior_dataInicio, Anterior_tipo) REFERENCES Calendario (dataInicio, tipo) ON DELETE CASCADE,
	CONSTRAINT Calendario_Posterior_FK FOREIGN KEY (Posterior_dataInicio, Posterior_tipo) REFERENCES Calendario (dataInicio, tipo) ON DELETE CASCADE,
	CONSTRAINT EhAnterior_PK PRIMARY KEY (Anterior_dataInicio, Anterior_tipo, Posterior_dataInicio, Posterior_tipo)
);

-- ENADE
CREATE TABLE Enade (
	realizacao date DEFAULT 'now()',
	nota numeric(4,2),
	Estudante_ra integer,
	Estudante_Pessoa_rg character varying(9),
	Curso_codigo integer,

	CONSTRAINT Enade_Estudante_FK FOREIGN KEY (Estudante_Pessoa_rg, Estudante_ra) REFERENCES Estudante (Pessoa_rg, ra) ON DELETE CASCADE,
	CONSTRAINT Enade_Curso_FK FOREIGN KEY (Curso_codigo) REFERENCES Curso (codigo) ON DELETE CASCADE,
	CONSTRAINT Enade_PK PRIMARY KEY (Estudante_ra, Curso_codigo, realizacao)
);