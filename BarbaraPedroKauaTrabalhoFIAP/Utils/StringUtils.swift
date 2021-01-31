//
//  StringUtils.swift
//  BarbaraPedroKauaTrabalhoFIAP
//
//  Created by Bárbara Perretti on 31/01/21.
//

import Foundation

public enum GeneralStringUtils: String {
    case addText = "Adicionar"
    case editText = "Editar"
    case saveText = "Cadastrar"
    case editProductText = "Editar Produto"
    case saveProductText = "Cadastrar Produto"
    case cancelText = "Cancelar"
    case nameStateText = "Nome do estado"
    case taxText = "Imposto"
    case deleteText = "Deletar"
    case doneText = "Done"
    case okText = "Ok"
    case selectImageTitleText = "Selecionar imagem do produto"
    case selectImageMsgText = "De onde você gostaria de selecionar a imagem?"
    case cameraText = "Câmera"
    case libraryText = "Biblioteca de fotos"
    case albumText = "Álbum de fotos"
    case registerInvalidTitleText = "Cadastro inválido"
    case registerInvalidMsgText = "Preencha todos os campos"
}

public enum CoreDataStringUtils: String {
    case nameSort = "name"
    case errorState = "Error states db"
    case errorProductSave = "Error to save a product in db"
    case errorStateDelete = "Erro to delete a state from db"
    case errorProductDelete = "Error to delete a product in db"
}

public enum UserDefaultStringUtils: String {
    case dolarValue
    case iofValue
}

public enum CellIdentifiersStringUtils: String {
   case stateCellIdentifier
   case purchaseCellIdentifier
}

public enum NibCellStringUtils: String {
    case StateTableViewCell
}
