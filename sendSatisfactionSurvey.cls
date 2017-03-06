public with sharing class sendSatisfactionSurvey {
	public sendSatisfactionSurvey() {
        // Create list of emails
        List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();

        emailHelper eHelper = new emailHelper();

        // Set template to use
        EmailTemplate emailTemp = [SELECT Id FROM EmailTemplate WHERE Name = 'Client Satisfaction - 12.29' limit 1];
        String templateId = emailTemp.Id;
        //Set reply to address
        String replyTo = 'lnichols@nextep.com';
        //Set displayname
        String displayName = 'Nextep, Inc.';

        // Get list of contacts
        List<Contact> recipientList = new List<Contact>([
            SELECT Id
            FROM Contact
            WHERE HasOptedOutOfEmail = FALSE
            AND Email != null
            AND (ClientAdministrator__c = TRUE OR Benefits__c = TRUE OR HR__c = TRUE OR Key_Executive__c = TRUE OR Payroll__c = TRUE OR Owner__c = TRUE OR Risk__c = True)
            AND Account.Status__c = 'Client'
            AND Account.NextCSATSent__c = THIS_MONTH]);

        Messaging.reserveSingleEmailCapacity(recipientList.size());
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        //Use emailHelper to create an email for each contact in the list, add them to the list of emails
        for(Contact c:recipientList){
            mail = eHelper.createEmailFromTemplate(templateId, c.Id, replyTo, displayName);
            allMails.add(mail);
        }

        // Try sending emails
        try {
            Messaging.SendEmail(allMails, false);
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
	}
}