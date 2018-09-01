# My-Journey

  MyJourney is an iOS Application for tracking journeys on map and saving coordinates, timestamps, speed and other data about them.
  Application uses a local Realm database encrypted.

Notes:
  UI slows down a lot because of location manager updating process
  There were been tried multiple solution with DeferredLocationUpdates, MonitoringSignificantLocationChanges, not displaying user's location on map and other
  Still searching for a better solution 
  
  When an iOS app is uninstalled from a device, all of the files associated with it are deleted (including any Realm files).
  For storing data even the user deletes the app, a good solution is to use a server side.
 
  For example, Firebase could be used to store data for users.
  For data separation, they can either make an "account" with an unique username or using a device ID to keep their data apart.
  This would change the database architecture a little, being required replacement of Coorinates inside Journey with uuids.

