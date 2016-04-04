package org.bigbluebutton.core
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;

	public class FileUploadService
	{
		private var request:URLRequest = new URLRequest();
		private var sendVars:URLVariables = new URLVariables();
		
		public function FileUploadService(url:String, conference:String, room:String):void {
			sendVars.conference = conference;
			sendVars.room = room;
			request.url = url;
			request.data = sendVars;
		}
		
		public function upload(presentationName:String, file:FileReference):void {
			sendVars.presentation_name = presentationName;
			var fileToUpload : FileReference = new FileReference();
			fileToUpload = file;
			
			fileToUpload.addEventListener(Event.COMPLETE, onUploadComplete);
			fileToUpload.addEventListener(IOErrorEvent.IO_ERROR, onUploadIoError);
			fileToUpload.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onUploadSecurityError);
			
			request.method = URLRequestMethod.POST;
			
			// "fileUpload" is the variable name of the uploaded file in the server
			fileToUpload.upload(request, "fileUpload", true);
		}

		private function onUploadComplete(event:Event):void {
		}

		private function onUploadIoError(event:IOErrorEvent):void {
			if(event.errorID != 2038){ //upload works despite of this error.
				trace("onUploadIoError text: " + event.text + ", errorID: " + event.errorID);
			}
			
		}
		
		private function onUploadSecurityError(event:SecurityErrorEvent) : void {
			trace("A security error occured while trying to upload the presentation. " + event.toString());
		}		


	}
}