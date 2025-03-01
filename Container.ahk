#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force

; Create a GUI
myGui := Gui("+Resize", "Container Demo")
myGui.OnEvent("Close", (*) => ExitApp())

; Create containers
formContainer := GuiContainer(myGui, "x10 y10 w300 h200", "User Information")
optionsContainer := GuiContainer(myGui, "x300 y10 w200 h200", "Options")

; Add controls to form container
formContainer.AddText("", "Name:")
formContainer.AddEdit("vName w280", "")
formContainer.AddText("", "Email:")
formContainer.AddEdit("vEmail w280", "")

; Global variable for state
global toggleVisible := true

; Callbacks
SubmitForm(ctrl, *) {
    data := ctrl.gui.Submit(false)
    MsgBox("Name: " data["Name"] "`nEmail: " data["Email"])
}

ToggleForm(*) {
    global toggleVisible, formContainer
    toggleVisible := !toggleVisible
    if toggleVisible
        formContainer.Show()
    else
        formContainer.Hide()
}

; Add buttons
submitBtn := formContainer.AddButton("Default w100", "Submit")
if submitBtn
    submitBtn.OnEvent("Click", SubmitForm)

; Add controls to options container
optionsContainer.AddCheckbox("vOptEmail", "Send email confirmation")
optionsContainer.AddCheckbox("vOptSave", "Save information")
toggleBtn := optionsContainer.AddButton("w100", "Toggle Form")
if toggleBtn
    toggleBtn.OnEvent("Click", ToggleForm)

; Show the GUI
myGui.Show()

class GuiContainer {
    _gui := ""
    _groupBox := ""
    _controls := Map()
    _x := 0
    _y := 0
    _width := 200
    _height := 200
    _title := ""
    _padding := 10
    _nextY := 0
    _spacing := 5

    __New(gui, options := "", title := "") {
        this._gui := gui
        this._title := title
        this._ParseOptions(options)
        this._groupBox := this._gui.AddGroupBox("x" this._x " y" this._y " w" this._width " h" this._height, title)
        this._nextY := this._y + this._padding
    }
    
    _ParseOptions(options) {
        if (options = "")
            return
            
        regEx := "i)(?:^|\s)(x|y|w|h)(\d+)"
        startPos := 1
        
        while (pos := RegExMatch(options, regEx, &match, startPos)) {
            startPos := pos + StrLen(match[0])
            
            switch (match[1]) {
                case "x": this._x := Integer(match[2])
                case "y": this._y := Integer(match[2])
                case "w": this._width := Integer(match[2])
                case "h": this._height := Integer(match[2])
            }
        }
    }
    
    AddText(options := "", text := "") {
        return this._AddControl("Text", options, text)
    }
    
    AddEdit(options := "", text := "") {
        return this._AddControl("Edit", options, text)
    }
    
    AddButton(options := "", text := "") {
        return this._AddControl("Button", options, text)
    }
    
    AddListBox(options := "", items := "") {
        return this._AddControl("ListBox", options, items)
    }
    
    AddDropDownList(options := "", items := "") {
        return this._AddControl("DropDownList", options, items)
    }
    
    AddComboBox(options := "", items := "") {
        return this._AddControl("ComboBox", options, items)
    }
    
    AddListView(options := "", headers := "") {
        return this._AddControl("ListView", options, headers)
    }
    
    AddTreeView(options := "", content := "") {
        return this._AddControl("TreeView", options, content)
    }
    
    AddPicture(options := "", filename := "") {
        return this._AddControl("Picture", options, filename)
    }
    
    AddGroupBox(options := "", text := "") {
        return this._AddControl("GroupBox", options, text)
    }
    
    AddCheckbox(options := "", text := "") {
        return this._AddControl("Checkbox", options, text)
    }
    
    AddRadio(options := "", text := "") {
        return this._AddControl("Radio", options, text)
    }
    
    AddTab3(options := "", titles := "") {
        return this._AddControl("Tab3", options, titles)
    }
    
    AddProgress(options := "", value := "") {
        return this._AddControl("Progress", options, value)
    }
    
    AddUpDown(options := "", value := "") {
        return this._AddControl("UpDown", options, value)
    }
    
    AddHotkey(options := "", content := "") {
        return this._AddControl("Hotkey", options, content)
    }
    
    AddMonthCal(options := "", content := "") {
        return this._AddControl("MonthCal", options, content)
    }
    
    AddLink(options := "", text := "") {
        return this._AddControl("Link", options, text)
    }
    
    _AddControl(type, options, content) {
        varName := ""
        if (RegExMatch(options, "i)\bv([a-zA-Z0-9_]+)", &match))
            varName := match[1]
        
        adjustedOptions := this._AdjustOptions(options)
        
        control := ""
        try {
            switch type {
                case "Text": control := this._gui.AddText(adjustedOptions, content)
                case "Edit": control := this._gui.AddEdit(adjustedOptions, content)
                case "Button": control := this._gui.AddButton(adjustedOptions, content)
                case "ListBox": control := this._gui.AddListBox(adjustedOptions, content)
                case "DropDownList": control := this._gui.AddDropDownList(adjustedOptions, content)
                case "ComboBox": control := this._gui.AddComboBox(adjustedOptions, content)
                case "ListView": control := this._gui.AddListView(adjustedOptions, content)
                case "TreeView": control := this._gui.AddTreeView(adjustedOptions, content)
                case "Picture": control := this._gui.AddPicture(adjustedOptions, content)
                case "GroupBox": control := this._gui.AddGroupBox(adjustedOptions, content)
                case "Checkbox": control := this._gui.AddCheckbox(adjustedOptions, content)
                case "Radio": control := this._gui.AddRadio(adjustedOptions, content)
                case "Tab3": control := this._gui.AddTab3(adjustedOptions, content)
                case "Progress": control := this._gui.AddProgress(adjustedOptions, content)
                case "UpDown": control := this._gui.AddUpDown(adjustedOptions, content)
                case "Hotkey": control := this._gui.AddHotkey(adjustedOptions, content)
                case "MonthCal": control := this._gui.AddMonthCal(adjustedOptions, content)
                case "Link": control := this._gui.AddLink(adjustedOptions, content)
                default: throw Error("Unknown control type: " type)
            }
        } catch as err {
            MsgBox("Error adding control: " err.Message)
            return ""
        }
        
        if (control) {
            if (varName)
                this._controls[varName] := control
            else
                this._controls[type "_" A_Index] := control
                
            ; Use GetPos instead of Pos property
            x := 0, y := 0, w := 0, h := 0
            control.GetPos(&x, &y, &w, &h)
            this._nextY := y + h + this._spacing
        }
        
        return control
    }
    
    _AdjustOptions(options) {
        xPos := this._x + this._padding
        yPos := this._nextY
        
        if (RegExMatch(options, "i)(?:^|\s)x(\d+|\+\d+)", &matchX)) {
            if (SubStr(matchX[1], 1, 1) = "+")
                xPos += Integer(SubStr(matchX[1], 2))
            else
                xPos := this._x + this._padding + Integer(matchX[1])
            
            options := RegExReplace(options, "i)(?:^|\s)x(\d+|\+\d+)", " ")
        }
        
        if (RegExMatch(options, "i)(?:^|\s)y(\d+|\+\d+)", &matchY)) {
            if (SubStr(matchY[1], 1, 1) = "+")
                yPos := this._nextY + Integer(SubStr(matchY[1], 2))
            else
                yPos := this._y + this._padding + Integer(matchY[1])
            
            options := RegExReplace(options, "i)(?:^|\s)y(\d+|\+\d+)", " ")
        }
        
        if (!RegExMatch(options, "i)(?:^|\s)w(\d+|\+\d+)")) {
            maxWidth := this._width - (this._padding * 2)
            options := "w" maxWidth " " options
        }
        
        options := Trim(RegExReplace(options, "\s+", " "))
        return "x" xPos " y" yPos " " options
    }
    
    GetControl(name) {
        return this._controls.Has(name) ? this._controls[name] : ""
    }
    
    Move(x, y) {
        xOffset := x - this._x
        yOffset := y - this._y
        
        this._groupBox.Move(x, y)
        
        for _, control in this._controls {
            ctrlX := 0, ctrlY := 0, ctrlW := 0, ctrlH := 0
            control.GetPos(&ctrlX, &ctrlY, &ctrlW, &ctrlH)
            control.Move(ctrlX + xOffset, ctrlY + yOffset)
        }
        
        this._x := x
        this._y := y
        this._nextY += yOffset
    }
    
    Resize(width, height) {
        this._groupBox.Move(,, width, height)
        this._width := width
        this._height := height
    }
    
    Show() {
        this._groupBox.Visible := true
        for _, control in this._controls
            control.Visible := true
    }
    
    Hide() {
        this._groupBox.Visible := false
        for _, control in this._controls
            control.Visible := false
    }
    
    Enable() {
        for _, control in this._controls
            control.Enabled := true
    }
    
    Disable() {
        for _, control in this._controls
            control.Enabled := false
    }
    
    SetSpacing(spacing) {
        this._spacing := spacing
    }
    
    SetPadding(padding) {
        this._padding := padding
    }
    
    ; Properties
    x {
        get {
            return this._x
        }
    }
    
    y {
        get {
            return this._y
        }
    }
    
    width {
        get {
            return this._width
        }
    }
    
    height {
        get {
            return this._height
        }
    }
    
    title {
        get {
            return this._title
        }
        set {
            this._title := value
            this._groupBox.Text := value
        }
    }
    
    groupBox {
        get {
            return this._groupBox
        }
    }
    
    controls {
        get {
            return this._controls
        }
    }
}
