---@type Promise<boolean> | nil
local dialogRes

FM.dialog = {}

---@class DialogProps
---@field title? string
---@field message? string
---@field confirmLabel? string
---@field cancelLabel? string
---@field keepInput? boolean

local function setDefaultProps(props)
    if not props then props = {} end
    props.title = props.title or ''
    props.message = props.message or ''
    props.confirmLabel = props.confirmLabel or 'Confirm'
    props.cancelLabel = props.cancelLabel or 'Cancel'
    props.keepInput = props.keepInput or false

    return props
end

---@param props DialogProps | nil
function FM.dialog.open(props)
    if dialogRes then return FM.console.err('Dialog already open') end
    
    props = setDefaultProps(props)
    dialogRes = promise.new()
    
    SetNuiFocus(true, true)
    SetNuiFocusKeepInput(props.keepInput)

    SendNUIMessage({
        action = 'openDialog',
        data = props
    })

    return Citizen.Await(dialogRes)
end

---@param result 'cancel' | 'confirm'
function FM.dialog.close(result)
    if not dialogRes then return FM.console.err('No dialog open') end

    SendNUIMessage({
        action = 'closeDialog',
        data = result
    })
end

RegisterNUICallback('dialogClosed', function(res, cb)
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)

    if dialogRes then
        dialogRes:resolve(res)
        dialogRes = nil
    end

    cb(true)
end)

---@return boolean
function FM.dialog.isOpen()
    return dialogRes ~= nil
end

--[[ EXAMPLE FOR NOW HERE ]]
RegisterCommand('opendialog', function (source, args, raw)
    local result = FM.dialog.open({
        title = 'Test',
        message = 'This is a test dialog',
    })
    FM.console.debug({ result })
end)

RegisterCommand('closedialog', function (source, args, raw)
    FM.dialog.close('confirm')
end)