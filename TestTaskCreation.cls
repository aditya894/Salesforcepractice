@isTest
public class TestTaskCreation {
	@testSetup
    static void testSetup(){
     List<Account> accounts=new List<Account>();
     accounts.add(new Account(name='Account A', AccountNumber=null));
     accounts.add(new Account(name='Account B', AccountNumber=null));
     accounts.add(new Account(name='Account C',AccountNumber='24548'));
     insert accounts;
    }
    
    @isTest
    public static void testCreateTask(){
        List<Account> accounts=[Select Id, Name, AccountNumber, OwnerId from Account where Name like '%Account%'];
        Set<Id> ids=new Set<Id>();
        for(Account acc: accounts){
            ids.add(acc.id);
        }
        TaskCreation.createTask(accounts);
        List<Task> tasks=[Select Id, AccountId from Task];
        Test.startTest();
        System.assertEquals(6, tasks.size(), 'Size does not match, failed!');
        
        tasks[0].status='Completed';
        update tasks[0];
        
        List<Account> accountRecords=[Select Id,Description,Active__c, OwnerId from Account where Id=:tasks[0].AccountId];
     	System.assertEquals(true, accountRecords[0].Active__c, 'Not Active');
        Test.stopTest();
    }
    
}