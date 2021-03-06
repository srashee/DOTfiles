#!/usr/bin/env python
from __future__ import print_function
import httplib2
import os

from apiclient import discovery
from oauth2client import client
from oauth2client import tools
from oauth2client.file import Storage
import datetime

def main():
    """Shows basic usage of the Google Calendar API.

    Creates a Google Calendar API service object and outputs a list of the next
    10 events on the user's calendar.
    """
    credentials = get_credentials()
    http = credentials.authorize(httplib2.Http())
    service = discovery.build('calendar', 'v3', http=http)

    now = datetime.datetime.utcnow().isoformat() + 'Z' # 'Z' indicates UTC time
    eventsResult = service.events().list(
        calendarId='primary', timeMin=now, maxResults=1, singleEvents=True,
        orderBy='startTime').execute()
    events = eventsResult.get('items', [])


    if not events:
        print('No upcoming events found.')
    for event in events:
        temp = ""
        pstr = ""
        start = event['start'].get('dateTime', event['start'].get('date'))
        start = start.split('T', 1)
        pstr = start[0]
        #+ " "
        start = start[1].split(':', 2)
        #pstr = pstr + start[0] + ":" + start[1]
        temp = start[0] + ":" + start[1]
        d = datetime.datetime.strptime(temp, "%H:%M")
        d = d.strftime("%I:%M %p")
        #print (d)
        pstr = datetime.datetime.strptime(pstr,'%Y-%m-%d').strftime('%b-%d')
        start = pstr + " " +  d
        print(start, event['summary'])


if __name__ == '__main__':
    main()
