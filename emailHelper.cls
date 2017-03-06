global with sharing class emailHelper {
    public emailHelper() { }

    //Creates a SingleEmailMessage accepting parameters for template Id, recipient Id (Contact), reply to address, and display name.
    public Messaging.SingleEmailMessage createEmailFromTemplate (String templateId, String recipientId, String replyTo, String displayName) {

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        mail.setTemplateId(templateId);
        mail.setTargetObjectId(recipientId);
        mail.setReplyTo(replyTo);
        mail.setSenderDisplayName(displayName);

        return mail;
    }

}