Public Sub Stopman()
    MsgBox "Stopman"
    ' End
End Sub

Public Sub Debug_CopySheetToNewBook( _
        ByVal src As Worksheet, _
        ByVal fileTitle As String)          '★必須引数に変更

    Dim dbgBook  As Workbook
    Const saveDir As String = "FULL_PATH"   '★固定パス
    Dim baseName As String
    Dim fileName As String
    Dim counter  As Long

    Application.ScreenUpdating = False

    '--- ① シートコピー → 新規ブック生成 ---
    src.Copy
    Set dbgBook = ActiveWorkbook

    '--- ② シート名変更（任意。ここでは fileTitle を使用） ---
    dbgBook.Worksheets(1).Name = fileTitle

    '--- ③ 保存フォルダー存在確認／生成 ---
    If Dir(saveDir, vbDirectory) = "" Then MkDir saveDir

    '--- ④ ファイル名決定 ---
    baseName = "debug_" & fileTitle
    fileName = baseName & ".xlsx"
    If Dir(saveDir & fileName) <> "" Then
        counter = 1
        Do While Dir(saveDir & baseName & "(" & counter & ").xlsx") <> ""
            counter = counter + 1
        Loop
        fileName = baseName & "(" & counter & ").xlsx"
    End If

    '--- ⑤ 保存 ---
    dbgBook.SaveAs Filename:=saveDir & fileName, _
                FileFormat:=xlOpenXMLWorkbook   '51 = .xlsx

    '--- ⑥ ブックを閉じる ---
    dbgBook.Close SaveChanges:=False             '★追加ポイント

    '--- ⑦ 元ブックへフォーカスを戻す ---
    ThisWorkbook.Activate
    Application.ScreenUpdating = True
    Call Wait(1)
End Sub

Public Sub Debug_CopyBookToNewBook( _
        ByVal srcBook As Workbook, _
        ByVal fileTitle As String)

    Dim dbgBook  As Workbook
    Const saveDir As String = _
        "FULL_PATH"
    Dim baseName As String
    Dim fileName As String
    Dim counter  As Long

    Application.ScreenUpdating = False

    '--- ① ブックコピー → 新規ブック生成 ---
    srcBook.Worksheets.Copy                    '全シートを一括コピー
    Set dbgBook = ActiveWorkbook               'ここで出来るのがデバッグ用ブック

    '--- ② 先頭シート名変更（任意：fileTitle を使用）---
    dbgBook.Worksheets(1).Name = fileTitle

    '--- ③ 保存フォルダー存在確認／生成 ---
    If Dir(saveDir, vbDirectory) = "" Then MkDir saveDir

    '--- ④ ファイル名決定（重複回避ロジック）---
    baseName = "debug_" & fileTitle
    fileName = baseName & ".xlsx"
    If Dir(saveDir & fileName) <> "" Then
        counter = 1
        Do While Dir(saveDir & baseName & "(" & counter & ").xlsx") <> ""
            counter = counter + 1
        Loop
        fileName = baseName & "(" & counter & ").xlsx"
    End If

    '--- ⑤ 保存 ---
    dbgBook.SaveAs Filename:=saveDir & fileName, _
                FileFormat:=xlOpenXMLWorkbook    '51 = .xlsx

    '--- ⑥ デバッグブックを閉じる ---
    dbgBook.Close SaveChanges:=False

    '--- ⑦ 元ブックにフォーカスを戻す ---
    srcBook.Activate
    Application.ScreenUpdating = True

    '（お好みで）画面が瞬時に切り替わるのを緩和
    Call Wait(1)
End Sub