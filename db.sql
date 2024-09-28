-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema pvs
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema pvs
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pvs` DEFAULT CHARACTER SET utf8 ;
USE `pvs` ;

-- -----------------------------------------------------
-- Table `pvs`.`User`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pvs`.`User` (
  `userId` INT ZEROFILL NOT NULL AUTO_INCREMENT,
  `firstName` VARCHAR(45) NOT NULL,
  `lastName` VARCHAR(45) NULL,
  `patronymic` VARCHAR(45) NULL,
  `email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `createdAt` DATETIME NOT NULL,
  PRIMARY KEY (`userId`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pvs`.`Conference`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pvs`.`Conference` (
  `name` VARCHAR(45) NOT NULL,
  `createdAt` DATETIME NOT NULL,
  `duration` INT NOT NULL,
  `User_userId` INT ZEROFILL NOT NULL,
  PRIMARY KEY (`createdAt`, `User_userId`),
  INDEX `fk_Conference_User1_idx` (`User_userId` ASC) VISIBLE,
  CONSTRAINT `fk_Conference_User1`
    FOREIGN KEY (`User_userId`)
    REFERENCES `pvs`.`User` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pvs`.`Record`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pvs`.`Record` (
  `recordId` INT ZEROFILL NOT NULL AUTO_INCREMENT,
  `createdAt` DATETIME NOT NULL,
  `duration` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `startedAt` DATETIME NOT NULL,
  `Conference_createdAt` DATETIME NOT NULL,
  `Conference_User_userId` INT ZEROFILL NOT NULL,
  PRIMARY KEY (`recordId`, `createdAt`, `Conference_createdAt`, `Conference_User_userId`),
  INDEX `fk_Record_Conference1_idx` (`Conference_createdAt` ASC, `Conference_User_userId` ASC) VISIBLE,
  CONSTRAINT `fk_Record_Conference1`
    FOREIGN KEY (`Conference_createdAt` , `Conference_User_userId`)
    REFERENCES `pvs`.`Conference` (`createdAt` , `User_userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pvs`.`Group`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pvs`.`Group` (
  `groupId` INT ZEROFILL NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `createdAt` DATETIME NOT NULL,
  `User_userId` INT ZEROFILL NOT NULL,
  `Record_recordId` INT ZEROFILL NOT NULL,
  `Record_createdAt` DATETIME NOT NULL,
  `Record_Conference_createdAt` DATETIME NOT NULL,
  `Record_Conference_User_userId` INT ZEROFILL NOT NULL,
  PRIMARY KEY (`groupId`),
  INDEX `fk_Group_User1_idx` (`User_userId` ASC) VISIBLE,
  INDEX `fk_Group_Record1_idx` (`Record_recordId` ASC, `Record_createdAt` ASC, `Record_Conference_createdAt` ASC, `Record_Conference_User_userId` ASC) VISIBLE,
  CONSTRAINT `fk_Group_User1`
    FOREIGN KEY (`User_userId`)
    REFERENCES `pvs`.`User` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Group_Record1`
    FOREIGN KEY (`Record_recordId` , `Record_createdAt` , `Record_Conference_createdAt` , `Record_Conference_User_userId`)
    REFERENCES `pvs`.`Record` (`recordId` , `createdAt` , `Conference_createdAt` , `Conference_User_userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pvs`.`Participant`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pvs`.`Participant` (
  `participantId` INT ZEROFILL NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `connectionDate` DATETIME NOT NULL,
  `disconnetionDate` DATETIME NOT NULL,
  `User_userId` INT ZEROFILL NULL,
  `Conference_conferenceId` INT ZEROFILL NOT NULL,
  PRIMARY KEY (`participantId`),
  INDEX `fk_Participant_User1_idx` (`User_userId` ASC) VISIBLE,
  CONSTRAINT `fk_Participant_User1`
    FOREIGN KEY (`User_userId`)
    REFERENCES `pvs`.`User` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pvs`.`Message`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pvs`.`Message` (
  `text` VARCHAR(45) NOT NULL,
  `createdAt` DATETIME NOT NULL,
  `Participant_participantId` INT ZEROFILL NOT NULL,
  `Conference_createdAt` DATETIME NOT NULL,
  `Conference_User_userId` INT ZEROFILL NOT NULL,
  PRIMARY KEY (`Participant_participantId`, `createdAt`, `Conference_createdAt`, `Conference_User_userId`),
  INDEX `fk_Message_Participant1_idx` (`Participant_participantId` ASC) VISIBLE,
  INDEX `fk_Message_Conference1_idx` (`Conference_createdAt` ASC, `Conference_User_userId` ASC) VISIBLE,
  CONSTRAINT `fk_Message_Participant1`
    FOREIGN KEY (`Participant_participantId`)
    REFERENCES `pvs`.`Participant` (`participantId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Message_Conference1`
    FOREIGN KEY (`Conference_createdAt` , `Conference_User_userId`)
    REFERENCES `pvs`.`Conference` (`createdAt` , `User_userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pvs`.`Group_has_User`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pvs`.`Group_has_User` (
  `Group_groupId` INT ZEROFILL NOT NULL,
  `User_userId` INT ZEROFILL NOT NULL,
  PRIMARY KEY (`Group_groupId`, `User_userId`),
  INDEX `fk_Group_has_User_User1_idx` (`User_userId` ASC) VISIBLE,
  INDEX `fk_Group_has_User_Group1_idx` (`Group_groupId` ASC) VISIBLE,
  CONSTRAINT `fk_Group_has_User_Group1`
    FOREIGN KEY (`Group_groupId`)
    REFERENCES `pvs`.`Group` (`groupId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Group_has_User_User1`
    FOREIGN KEY (`User_userId`)
    REFERENCES `pvs`.`User` (`userId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
