create database inkView;
use inkView;

CREATE TABLE IF NOT EXISTS  endereco  (
     idEndereco  INT NOT NULL AUTO_INCREMENT,
     complemento  VARCHAR(45) NULL,
     cep  CHAR(8) NULL,
     descricao  VARCHAR(200) NULL,
    PRIMARY KEY ( idEndereco )
);
  

CREATE TABLE IF NOT EXISTS  empresa  (
   idEmpresa  INT NOT NULL AUTO_INCREMENT,
   razaoSocial  VARCHAR(100) NOT NULL,
   cnpj  CHAR(14) NOT NULL,
   email  VARCHAR(100) NOT NULL,
   fkEndereco  INT NOT NULL,
   fkSede  INT,
  PRIMARY KEY ( idEmpresa ),
  CONSTRAINT  fk_empresa_endereco1 
    FOREIGN KEY ( fkEndereco )
    REFERENCES  endereco  ( idEndereco )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT  fk_empresa_empresa1 
    FOREIGN KEY ( fkSede )
    REFERENCES  empresa  ( idEmpresa )
);


CREATE TABLE IF NOT EXISTS  funcionario  (
   idFuncionario  INT NOT NULL AUTO_INCREMENT,
   fkGestor  INT NULL,
   fkEmpresa  INT NOT NULL,
   nome  VARCHAR(45) NULL,
   email  VARCHAR(45) NULL,
   cpf  CHAR(14) NULL,
   telefone  VARCHAR(45) NULL,
   senha  VARCHAR(45) NULL,
  PRIMARY KEY ( idFuncionario ,  fkEmpresa ),
  CONSTRAINT  fk_funcionario_funcionario1 
    FOREIGN KEY ( fkGestor )
    REFERENCES  funcionario  ( idFuncionario ),
  CONSTRAINT  fk_funcionario_empresa1 
    FOREIGN KEY ( fkEmpresa )
    REFERENCES  empresa  ( idEmpresa )
);


CREATE TABLE IF NOT EXISTS ligacoesFuncionario (
   idligacoesFuncionario INT NOT NULL AUTO_INCREMENT,
   recebidas int ,
   atendidas int,
   porcAtendidas double,
   abandonadas int,
   duracao time,
   fkFuncionario INT NOT NULL,
   PRIMARY KEY (idLigacoesFuncionario),
   CONSTRAINT fk_chamada_funcionario1 
      FOREIGN KEY (fkFuncionario)
      REFERENCES funcionario (idFuncionario)
);


CREATE TABLE IF NOT EXISTS  computador  (
   idComputador  INT NOT NULL AUTO_INCREMENT,
   ipComputador  VARCHAR(45),
   nomePatrimonio  VARCHAR(45) NULL,
   marca  VARCHAR(45) NULL,
   fkFuncionario  INT NOT NULL,
   sistemaOperacional  VARCHAR(100) NULL,
   ativo BOOLEAN,
  PRIMARY KEY ( idComputador ,  fkFuncionario ),
  CONSTRAINT  fk_computador_funcionario1 
    FOREIGN KEY ( fkFuncionario )
    REFERENCES  funcionario  ( idFuncionario )
    );


CREATE TABLE IF NOT EXISTS  unidadeMedida  (
   idUnidadeMedida  INT NOT NULL AUTO_INCREMENT,
   tipoMedida  VARCHAR(100) NULL,
  PRIMARY KEY ( idUnidadeMedida ));


CREATE TABLE IF NOT EXISTS  componente  (
   idComponente  INT NOT NULL AUTO_INCREMENT,
   tipo  VARCHAR(45) NOT NULL,
   fkUnidadeMedida  INT NOT NULL,
  PRIMARY KEY ( idComponente ),
  CONSTRAINT  fk_componente_unidadeMedida1 
    FOREIGN KEY ( fkUnidadeMedida )
    REFERENCES  unidadeMedida  ( idUnidadeMedida )
);


CREATE TABLE IF NOT EXISTS  software  (
   idSoftware  INT NOT NULL AUTO_INCREMENT,
   nomeSoftware  VARCHAR(150) NOT NULL,
   categoriaSoftware  VARCHAR(45) NULL,
  PRIMARY KEY ( idSoftware ));


CREATE TABLE IF NOT EXISTS softwarePermitido (
    idSoftwarePermitido INT NOT NULL AUTO_INCREMENT,
    bloqueado BOOLEAN NULL,
    fkSoftware INT NOT NULL,
    fkComputador INT NOT NULL,
    PRIMARY KEY (idSoftwarePermitido, fkSoftware, fkComputador),
    CONSTRAINT fk_computador_has_Software_Software1 FOREIGN KEY (fkSoftware)
        REFERENCES software (idSoftware),
    CONSTRAINT fk_ComputadorSoftware_computador1 FOREIGN KEY (fkComputador)
        REFERENCES computador (idComputador)
);


CREATE TABLE IF NOT EXISTS  hasComponente  (
   idHasComponente  INT NOT NULL AUTO_INCREMENT,
   fkComponente  INT NOT NULL,
   fkComputador  INT NOT NULL,
  PRIMARY KEY ( idHasComponente ,  fkComponente ,  fkComputador ),
  CONSTRAINT  fk_componente_has_computador_componente1 
    FOREIGN KEY ( fkComponente )
    REFERENCES  componente  ( idComponente ),
  CONSTRAINT  fk_componentes_has_computador_computador1 
    FOREIGN KEY ( fkComputador )
    REFERENCES  computador  ( idComputador )
);


CREATE TABLE IF NOT EXISTS  registro  (
   idRegistro  INT NOT NULL AUTO_INCREMENT,
   registro  INT NULL,
   dtHora  DATETIME NULL,
   fkHasComponente  INT NOT NULL,
  PRIMARY KEY ( idRegistro ),
  CONSTRAINT  fk_registro_componenteComputador1 
    FOREIGN KEY ( fkHasComponente )
    REFERENCES  hasComponente  ( idHasComponente )
);


CREATE TABLE IF NOT EXISTS processo (
    idProcesso INT NOT NULL AUTO_INCREMENT,
    nomeProcesso VARCHAR(150),
    fkComputador INT NOT NULL,
    PRIMARY KEY (idProcesso),
    CONSTRAINT fk_registros_computador1 FOREIGN KEY (fkComputador)
        REFERENCES computador (idComputador)
);


CREATE TABLE IF NOT EXISTS registroProcesso (
  idRegistroProcesso INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  registro VARCHAR(150),
  fkProcesso INT,
  fkHasComponente INT,
  dataHora DATETIME,
  FOREIGN KEY (fkProcesso) REFERENCES processo(idProcesso),
  FOREIGN KEY (fkHasComponente) REFERENCES hasComponente(idHasComponente)
);


CREATE TABLE if not exists processoIlicito(
	idProcessoIlicito INT PRIMARY KEY AUTO_INCREMENT,
    fkSoftware INT NOT NULL,
    dataHora DATE NOT NULL,
    FOREIGN KEY (fkSoftware) REFERENCES softwarePermitido(idSoftwarePermitido)
);


CREATE TABLE if not exists ilicitoRegistro(
	idRegistroIlicito INT PRIMARY KEY AUTO_INCREMENT,
    fkProcessoIlicito INT NOT NULL,
    dtHora DATETIME NOT NULL,
    FOREIGN KEY (fkProcessoIlicito) REFERENCES processoIlicito(idProcessoIlicito)
);



INSERT INTO  endereco  ( idEndereco ,  complemento ,  cep ,  descricao ) VALUES
(null, 'Setor de Atendimento ao Cliente', '54321987', 'Localizada em um bairro comercial movimentado, próxima a restaurantes e lojas locais.');

INSERT INTO  empresa  ( idEmpresa ,  razaoSocial ,  cnpj ,  email ,  fkEndereco ,  fkSede ) VALUES
(null, 'Call Center ABC', '12345678901234', 'contato@callcenterabc.com', 1, NULL);

INSERT INTO  funcionario  ( idFuncionario ,  fkGestor ,  fkEmpresa ,  nome ,  email ,  cpf ,  telefone ,  senha ) VALUES
(null, NULL, 1, 'Fernando Brandão', 'fernando@callcenterabc.com', '12345678901', '(11) 1234-5678', 'senha123');

INSERT INTO  unidadeMedida  ( idUnidadeMedida ,  tipoMedida ) VALUES 
(null, '%'),
(null, 'GHz'),
(null, 'GB'),
(null, 'MB'),
(null, 'KB/s'),
(null, 'Inteiro');

INSERT INTO  componente  ( idComponente ,  tipo ,  fkUnidadeMedida ) VALUES 
(null, 'CPU', 1),
(null, 'Memoria', 1), 
(null, 'Memoria', 3), 
(null, 'Disco', 1),
(null, 'PPM', 6);



DELIMITER //
CREATE TRIGGER insere_hasComputadores
AFTER INSERT ON computador
FOR EACH ROW
BEGIN
    INSERT INTO hasComponente (fkComponente, fkComputador) VALUES 
     (1, NEW.idComputador),
     (2, NEW.idComputador),
     (3, NEW.idComputador),
     (4, NEW.idComputador),
     (5, NEW.idComputador);
END;
//
DELIMITER ;


CREATE VIEW vwIdComponenteComputador AS
select 
	idComputador,
	ipComputador,
	cpu1.idHasComponente as 'cpu',
	ram1.idHasComponente as 'ram',
    disco1.idHasComponente as 'disco'
from computador pc
	join hasComponente cpu1 on cpu1.fkComputador = pc.idComputador
    join hasComponente ram1 on ram1.fkComputador = pc.idComputador
    join hasComponente disco1 on disco1.fkComputador = pc.idComputador
		 join componente c on c.idComponente = cpu1.fkComponente
         join componente c1 on c1.idComponente = ram1.fkComponente
         join componente c2 on c2.idComponente = disco1.fkComponente
			join unidadeMedida u on u.idUnidadeMedida = c1.fkUnidadeMedida
				where c.tipo = 'CPU' 
                and  c2.tipo = 'Disco' 
                and c1.tipo = 'Memoria' 
                and u.tipoMedida = '%';


SET SQL_SAFE_UPDATES = 0;
UPDATE computador c
LEFT JOIN (
    SELECT hc.fkComputador, MAX(r.dtHora) AS UltimaDataHora
    FROM hasComponente hc
    LEFT JOIN registro r ON hc.idHasComponente = r.fkHasComponente
    WHERE r.dtHora >= NOW() - INTERVAL 5 MINUTE
    GROUP BY hc.fkComputador
) subquery ON c.idComputador = subquery.fkComputador
SET c.ativo = IF(subquery.UltimaDataHora IS NOT NULL, 1, 0);
