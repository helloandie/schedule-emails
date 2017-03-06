public with sharing class sendSatisfactionSurvey {
	public sendSatisfactionSurvey() {
        // Create list of emails
        List<Messaging.SingleEmailMessage> allMails = new List<Messaging.SingleEmailMessage>();
        //Get an instance of the emailHelper so we can use it later
        emailHelper eHelper = new emailHelper();
        // Set template to use
        EmailTemplate emailTemp = [SELECT Id FROM EmailTemplate WHERE Name = 'Client Satisfaction - 12.29' limit 1];
        String templateId = emailTemp.Id;
        //Set reply to address
        String replyTo = 'lnichols@nextep.com';
        //Set display name
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
        
        //Reserve some email slots
        Messaging.reserveSingleEmailCapacity(recipientList.size());
        //New single email message
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //Use emailHelper to create an email for each contact in the list, add them to the list of single email messages
        for(Contact c:recipientList){
            mail = eHelper.createEmailFromTemplate(templateId, c.Id, replyTo, displayName);
            allMails.add(mail);
        }

        //Now we need to update the account with the new LastCSATSent__c date of today:

        //Create a list of Accounts to update later
        List<Account> accToUpdate = new List<Account>();
        //Get list of accounts
        List<Account> accList = new List<Account>([
            SELECT Id
            FROM Account
            WHERE Status__c = 'Client'
            AND NextCSATSent__c = THIS_MONTH]);
        //Update the Last CSAT Sent field for each account in accList
        for(Account a: accList) {
            a.LastCSATSent__c = date.today();
            accToUpdate.add(a);
        }

        // Try sending emails and updating accounts
        try {
            Messaging.SendEmail(allMails, false);
            update accToUpdate;
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
	}
}