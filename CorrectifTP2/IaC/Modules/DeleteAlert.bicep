param actionGroupName string = 'Alert Delete'
param location string = 'Global'

var actionGroupEmail = '1843085@cegeplimoilou.ca'

resource AlertAction 'Microsoft.Insights/actionGroups@2023-01-01' = {
  name: actionGroupName
  location: 'Global'
  properties: {
    enabled: true
    groupShortName: actionGroupName
    emailReceivers: [
      {
        name: actionGroupName
        emailAddress: actionGroupEmail
        useCommonAlertSchema: true
      }
    ]
  }
}

param alertRuleName string = 'DocumentDeletedAlert'
param storageAccountName string = 'stdocuments120jgnj'

resource storageAccountAction 'Microsoft.Insights/ActionGroups/ActionRules@2023-01-01' = {
  name: '${AlertAction.name}/${alertRuleName}'
  location: 'Global'
  properties: {
    description: 'Alerte quand un document est supprimé'
    actions: [
      {
        actionGroupId: AlertAction.id
      }
    ]
    criteria: {
      allOf: [
        {
          equals: {
            field: 'category'
            operand: 'StorageBlobDelete'
          }
        }
        {
          equals: {
            field: 'status'
            operand: 'Succeeded'
          }
        }
      ]
    }
  }
}
