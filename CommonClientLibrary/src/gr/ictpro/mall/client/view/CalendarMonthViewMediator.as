package gr.ictpro.mall.client.view
{
	import flash.events.MouseEvent;
	
	import gr.ictpro.mall.client.components.TopBarDetailView;
	import gr.ictpro.mall.client.model.CalendarModel;
	import gr.ictpro.mall.client.model.ViewParameters;
	import gr.ictpro.mall.client.model.vo.Calendar;
	import gr.ictpro.mall.client.signal.ListErrorSignal;
	import gr.ictpro.mall.client.signal.ListSignal;
	import gr.ictpro.mall.client.signal.ListSuccessSignal;
	import gr.ictpro.mall.client.utils.ui.UI;

	public class CalendarMonthViewMediator extends TopBarCustomViewMediator
	{
		
		[Inject]
		public var calendarModel:CalendarModel;
		
		[Inject]
		public var listSignal:ListSignal;
		
		[Inject]
		public var listErrorSignal:ListErrorSignal;
		
		[Inject]
		public var listSuccessSignal:ListSuccessSignal;

		override public function onRegister():void
		{
			super.onRegister();
			eventMap.mapListener(view, "addClicked", addClicked);
			addToSignal(listSuccessSignal, listSuccess);
			addToSignal(listErrorSignal, listError);
			addToSignal(CalendarMonthView(view).dateSelected, dateClicked);
			listSignal.dispatch(Calendar);
			

		}

		private function dateClicked(date:Date):void
		{
			trace("date clicked: " + date);	
			var parameters:ViewParameters = new ViewParameters();
			parameters.vo = date;
			var detailView:CalendarDayView = new CalendarDayView();
			addView.dispatch(detailView, parameters, view);
			view.dispose();

		}
		
		private function listSuccess(classType:Class):void
		{
			if(classType == Calendar) {
				summarize();
			}
		}
		
		private function summarize():void
		{
			var daySummaries:Object = new Object();
			for each(var calendar:Calendar in calendarModel.list) {
				var date:Date = new Date(calendar.startTime.fullYear, calendar.startTime.month, calendar.startTime.date, 0,0,0,0);
				if(daySummaries[date] != null) {
					daySummaries[date] = daySummaries[date] +1;
				} else {
					daySummaries[date] = 1;
				}
			}
			CalendarMonthView(view).calendar.daySummaries = daySummaries;

		}
		
		
		private function listError(classType:Class, errorMessage:String):void
		{
			if(classType == Calendar) {
				UI.showError(errorMessage);
			}
		}

		private function addClicked(event:MouseEvent):void
		{
			var parameters:Object = buildParameters(calendarModel.create());
			showDetail(parameters);
		}
		
		private function buildParameters(vo:Object):ViewParameters
		{
			var parameters:ViewParameters = new ViewParameters();
			parameters.vo = vo;
			
			if(view.parameters != null && view.parameters.notification != null) {
				parameters.notification = view.parameters.notification; 
			}
			
			
			return parameters;
		}		

		private function showDetail(parameters:Object):void
		{
			var detailViewClass:Class = calendarModel.getViewClass();
			var detailView:TopBarDetailView = new detailViewClass() as TopBarDetailView;
			addView.dispatch(detailView, parameters, view);
			view.dispose();
		}

	}
}