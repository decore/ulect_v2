 # TwlPhoneNumber.coffee
    #
    # @description :: TODO: You might write a short summary of how this model works and what it represents here.
    # @docs        :: http://sailsjs.org/#!documentation/models
###
 "AC1f55fde014d561b9426c927e87bb02c3",
friendlyName: "(201) 877-5872",
phoneNumber: "+12018775872",
voiceUrl: null,
voiceMethod: "POST",
voiceFallbackUrl: null,
voiceFallbackMethod: "POST",
voiceCallerIdLookup: false,
dateCreated: "2015-01-13T08:06:09.000Z",
dateUpdated: "2015-01-13T08:06:10.000Z",
smsUrl: "https://3c59e40c.ngrok.com/api/v1/messages",
smsMethod: "POST",
smsFallbackUrl: "https://3c59e40c.ngrok.com/api/v1/messages/fallback",
smsFallbackMethod: "POST",
addressRequirements: "none",
statusCallback: "https://3c59e40c.ngrok.com/api/v1/messages/status",
statusCallbackMethod: "POST",
apiVersion: "2010-04-01",
voiceApplicationSid: "",
smsApplicationSid: ""
###
module.exports = {

    attributes:
        sid:
            type: "string"
            required: true
        accountSid:
            type: "string"
            required: true
        friendlyName:
            type: "string"
            required: true
        phoneNumber:
            type: "string"
            required: true
        smsUrl:
            type: "string"
            required: true
        smsFallbackUrl:
            type: "string"
            required: true
        smsFallbackMethod:
            type: "string"
            required: true
}
