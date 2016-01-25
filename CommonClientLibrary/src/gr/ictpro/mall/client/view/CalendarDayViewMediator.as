package gr.ictpro.mall.client.view
{
	import gr.ictpro.mall.client.components.TopBarListView;
	import gr.ictpro.mall.client.model.AbstractModel;
	import gr.ictpro.mall.client.model.CalendarModel;
	import gr.ictpro.mall.client.model.ViewParameters;
	import gr.ictpro.mall.client.model.vo.Calendar;
	import gr.ictpro.mall.client.utils.date.DateUtils;

	public class CalendarDayViewMediator extends TopBarListViewMediator
	{
		[Inject]
		public function set calendarModel(model:CalendarModel):void
		{
			super.model = model as AbstractModel;
		}
		
		
		override public function onRegister():void
		{
			super.onRegister();
		}

		override protected function listSuccess(classType:Class):void
		{
			if(classType == model.getVOClass()) {
				TopBarListView(view).data = model.getFilteredList(filterByDate);
			}
		}
		
		private function filterByDate(calendar:Object):Boolean
		{
			return DateUtils.compareNoTime(view.parameters.vo as Date, calendar.startTime as Date) == 0 || DateUtils.compareNoTime(view.parameters.vo as Date, calendar.endTime as Date) == 0;
		}

		override protected function buildParameters(vo:Object):ViewParameters
		{
			var parameters:ViewParameters = new ViewParameters();
			parameters.vo = vo;
			
			Calendar(parameters.vo).startTime.date = view.parameters.vo.date; 
			Calendar(parameters.vo).startTime.month = view.parameters.vo.month; 
			Calendar(parameters.vo).startTime.fullYear = view.parameters.vo.fullYear; 
			Calendar(parameters.vo).endTime.date = view.parameters.vo.date; 
			Calendar(parameters.vo).endTime.month = view.parameters.vo.month; 
			Calendar(parameters.vo).endTime.fullYear = view.parameters.vo.fullYear; 
			if(Calendar(parameters.vo).schedule != null) {
				Calendar(parameters.vo).schedule.startTime = Calendar(parameters.vo).startTime; 
				Calendar(parameters.vo).schedule.endTime = Calendar(parameters.vo).endTime;
			}
			
			if(view.parameters != null && view.parameters.notification != null) {
				parameters.notification = view.parameters.notification; 
			}
			
			
			return parameters;
		}		


	}
}