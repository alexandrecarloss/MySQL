-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema artemis
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema artemis
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `artemis` DEFAULT CHARACTER SET utf8 ;
USE `artemis` ;

-- -----------------------------------------------------
-- Table `artemis`.`pessoa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `artemis`.`pessoa` (
  `pescpf` VARCHAR(14) NOT NULL,
  `pesnumeroend` INT NULL,
  `pesrua` VARCHAR(50) NULL,
  `pesbairro` VARCHAR(50) NULL,
  `pescep` INT NULL,
  `pescidade` VARCHAR(50) NULL,
  `pesestado` VARCHAR(50) NULL,
  `pespais` VARCHAR(50) NULL,
  `paedtnascimento` DATE NULL,
  PRIMARY KEY (`pescpf`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `artemis`.`ong`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `artemis`.`ong` (
  `ongcodigo` INT NOT NULL AUTO_INCREMENT,
  `ongnumero` VARCHAR(15) NULL,
  `ongemail` VARCHAR(50) NULL,
  `ongemergencia` TINYINT NULL,
  `ongnumeroend` INT NULL,
  `ongrua` VARCHAR(50) NULL,
  `ongbairro` VARCHAR(50) NULL,
  `ongcep` INT(8) NULL,
  `ongcidade` VARCHAR(50) NULL,
  `ongestado` VARCHAR(50) NULL,
  `onpais` VARCHAR(50) NULL,
  PRIMARY KEY (`ongcodigo`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `artemis`.`pet`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `artemis`.`pet` (
  `petcodigo` INT NOT NULL AUTO_INCREMENT,
  `petidade` INT NULL,
  `pettipo` VARCHAR(30) NULL,
  `petnome` VARCHAR(50) NULL,
  `petsexo` CHAR NULL,
  `petporte` VARCHAR(50) NULL,
  `petinformacoes` VARCHAR(500) NULL,
  `petdisponivel` VARCHAR(20) NULL,
  `petraca` VARCHAR(50) NULL,
  `petpescpfoferece` VARCHAR(14) NULL,
  `petpescpfadota` VARCHAR(14) NULL,
  `petongcodigo` INT NULL,
  PRIMARY KEY (`petcodigo`, `petongcodigo`),
  INDEX `fk_pet_pessoa_idx` (`petpescpfoferece` ASC) VISIBLE,
  INDEX `fk_pet_pessoa1_idx` (`petpescpfadota` ASC) VISIBLE,
  INDEX `fk_pet_ong1_idx` (`petongcodigo` ASC) VISIBLE,
  CONSTRAINT `fk_pet_pessoa`
    FOREIGN KEY (`petpescpfoferece`)
    REFERENCES `artemis`.`pessoa` (`pescpf`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pet_pessoa1`
    FOREIGN KEY (`petpescpfadota`)
    REFERENCES `artemis`.`pessoa` (`pescpf`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pet_ong1`
    FOREIGN KEY (`petongcodigo`)
    REFERENCES `artemis`.`ong` (`ongcodigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `artemis`.`petfoto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `artemis`.`petfoto` (
  `petftoid` INT NOT NULL AUTO_INCREMENT,
  `petftocodigo` INT NOT NULL,
  `petftofoto` BLOB NOT NULL,
  INDEX `fk_petfoto_pet1_idx` (`petftocodigo` ASC) VISIBLE,
  PRIMARY KEY (`petftoid`, `petftocodigo`),
  CONSTRAINT `fk_petfoto_pet1`
    FOREIGN KEY (`petftocodigo`)
    REFERENCES `artemis`.`pet` (`petcodigo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
