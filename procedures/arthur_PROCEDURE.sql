-------------------------------------------------------------------------
-- Cadastrar Curso
create or replace function insereCurso
	(codigo integer,
	website character varying(40),
	nome character varying(40),
	coordenador coord
	)
returns void as $$
begin
	if codigo = null then
		raise exception 'Valor obrigatorio "Codigo" nulo, favor inserir valor valido.';
	else then
		insert into vw_curso values (codigo, website, nome, coordenador);
	end if;
end;
$$ language plpgsql called on null input;


-------------------------------------------------------------------------
-- Cadastrar Empresa
create or replace function insereEmpresa
	(cnpj bigint,
	nome character varying(20),
	endereco endereco
	)
returns void as $$
begin
	insert into vw_empresa values (cnpj, nome, endereco);
end;
$$ language plpgsql called on null input;


-------------------------------------------------------------------------
-- Cria relacao Estagia
create or replace function insereEstagia
	(Estudante_cpf character varying(15) NOT NULL,
	Empresa_cnpj bigint NOT NULL,
	dataInicio date,
	dataTermino date,
	supEmpresa supervisor,
	supUniversidade supervisor,
	cartaAvaliacao text,
	termoCompromisso text
	 )
returns void as $$
begin
	insert into vw_estagia values (Estudante_cpf, Empresa_cnpj, dataInicio,
                dataTermino, supEmpresa, supUniversidade, cartaAvaliacao, termoCompromisso); 
end;
$$ language plpgsql called on null input;
