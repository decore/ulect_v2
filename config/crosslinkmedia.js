/* 
 System settings 
 */

module.exports.crosslinkmedia = {
    siteURL: 'https://3c59e40c.ngrok.com', 
    statusCallback: 'https://3c59e40c.ngrok.com/api/v1/messages/status', 
    smsUrl: "https://3c59e40c.ngrok.com/api/v1/messages",
    smsFallbackUrl: "https://3c59e40c.ngrok.com/api/v1/messages/fallback"
}
//NOTE:
module.exports.twilioMasterAccount = {
        TWILIO_ACCOUNT_SID: 'ACc0d344677835c0a303c92d59cfa1b9d8',
        TWILIO_AUTH_TOKEN: 'e6dc7e7cceed05eedf5e644975cab642',
        TWILIO_NUMBER: '+18303550804',
        //statusCallback: 'http://newspaper-plan.cloudapp.net:3000/api/v1/messages/status'  
}