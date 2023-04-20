public with sharing class TaskCreation {
    
    public static void createTask(List<Account> accountRecords){
        
        if(null!=accountRecords){
        
            List<Task> tasks=new List<Task>();
            
            for(Account accountRecord: accountRecords){
            
                Task task=new Task();
                if(null!=accountRecord.AccountNumber){
                    task.Subject='Review Account '+accountRecord.AccountNumber;    
                }else if(null==accountRecord.AccountNumber){
                    task.Subject='Review Account '+accountRecord.Id;    
                }
                DateTime dt=System.now()+7;
                Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
                task.ActivityDate=myDate;
                task.OwnerId=accountRecord.OwnerId;
                task.Status='Not Started';
                task.WhatId=accountRecord.Id;
                tasks.add(task);
            }
            
            if(Schema.SObjectType.Task.isCreateable()){
                insert tasks;
            }    
        }
        
    }
    
    public static void updateAccountOnTaskCompletion(List<Task> taskRecordss){
        
        if(taskRecordss[0].Account.Active__c!=true){
          	 List<Task> tasks=[Select Id, AccountId from Task 
                          	where AccountId = :taskRecordss[0].AccountId AND status='Completed' WITH SECURITY_ENFORCED ORDER BY CreatedDate ASC ];
            Task taskRecord=tasks[0];
            if(null!=taskRecord){
                    //fetching list of related accounts
                    List<Account> accountRecords=[Select Id,Description,(Select Id, Description from Tasks)
                                                                            from Account where Id=:taskRecord.AccountId and Active__c=false WITH SECURITY_ENFORCED ];   
                    
                    //iterating and updating value of accountRecords
                    for(Account accountRecord : accountRecords){
                            accountRecord.Active__c=true;
                            accountRecord.Description=accountRecord.Tasks[0].Description;
                    }
                        
                    //updating accounts
                    if(Schema.SObjectType.Account.isUpdateable()){
                        update accountRecords;
                    }        	    
                 }  
        }
       
		}
    
}