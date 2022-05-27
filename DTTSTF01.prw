#Include "Totvs.ch"
/*/{Protheus.doc} DTTSTF01
Programa de exemplo de Refresh de MsNewGetDados

@type function
@version 1.0

@author Denis Tofoli (denis_tofoli@msn.com)
@since 27/05/2022
/*/
User Function DTTSTF01()
	Local   oDlg
	Private oGD
	Private aHeader := {}
	Private aCols   := {{"0001", "Item 0001", 0, 0, 0, .F.}}

	aAdd(aHeader,{"Item"      ,"T_ITEM" ,"@!"              ,04,0,""          ,,"C",""    ,})
	aAdd(aHeader,{"Descrição" ,"T_DESC" ,"@!"              ,30,0,""          ,,"C",""    ,})
	aAdd(aHeader,{"Quantidade","T_QUANT","@E 999,999"      ,06,0,""          ,,"N",""    ,})
	aAdd(aHeader,{"Preço"     ,"T_PRECO","@E 999,999.99"   ,09,0,""          ,,"N",""    ,})
	aAdd(aHeader,{"Total"     ,"T_TOTAL","@E 99,999,999.99",10,0,""          ,,"N",""    ,})

	DEFINE MSDIALOG oDlg TITLE "Refresh no MsNewGetDados" FROM 000, 000  TO 250, 600 PIXEL
		oGD := MsNewGetDados():New(0, 0, 100, 200,GD_INSERT+GD_UPDATE+GD_DELETE, /*[cLinhaOk]*/, /*[cTudoOk]*/, /*[cIniCpos]*/,{"T_QUANT","T_PRECO"} /*[aAlter]*/, /*[nFreeze]*/, /*[nMax]*/,"U_DTTST01V()" /*[cFieldOk]*/, /*[cSuperDel]*/, /*[cDelOk]*/, oDlg/*[oWnd]*/, aHeader/*[ aPartHeader]*/, aCols/*[aParCols]*/, /*[uChange]*/, /*[cTela]*/ )

        @ 105, 010 BUTTON oBtnInv PROMPT "Add Item" SIZE 037, 012 OF oDlg PIXEL ACTION AddItem()
        @ 105, 055 BUTTON oBtnInv PROMPT "Del Item" SIZE 037, 012 OF oDlg PIXEL ACTION DelItem()
        @ 105, 250 BUTTON oBtnLib PROMPT "Sair" SIZE 037, 012 OF oDlg PIXEL ACTION oDlg:End()

        oGD:oBrowse:Align := CONTROL_ALIGN_TOP
	ACTIVATE MSDIALOG oDlg CENTERED
Return nil

/*
Validador de campo, mas usado para preencher outro campo como gatilho
*/
User Function DTTST01V()
    Local nPosQtd := aScan(aHeader,{ |x| AllTrim(x[2]) == "T_QUANT" })
    Local nPosPrc := aScan(aHeader,{ |x| AllTrim(x[2]) == "T_PRECO" })
    Local nPosTot := aScan(aHeader,{ |x| AllTrim(x[2]) == "T_TOTAL" })
    Local cVar   := ReadVar()
    Local nValue := &cVar

    If cVar = "M->T_QUANT"
        aCols[n,nPosTot] := aCols[n,nPosPrc] * nValue
    ElseIf  cVar = "M->T_PRECO"
        aCols[n,nPosTot] := aCols[n,nPosQtd] * nValue
    EndIf
Return .T.

Static Function AddItem()
    aCols := aClone(oGD:aCols)

    aAdd(aCols, {StrZero(Len(aCols)+1,4), "Item " + StrZero(Len(aCols)+1,4), 0, 0, 0, .F.} )

    oGD:SetArray(aCols)
Return nil

Static Function DelItem()
    Local aNew := {}

    aCols := aClone(oGD:aCols)
    aEval(aCols, {|x| aAdd(aNew, x) }, 1, Len(aCols) - 1)
    aCols := aClone(aNew)

    oGD:SetArray(aCols)
Return nil
