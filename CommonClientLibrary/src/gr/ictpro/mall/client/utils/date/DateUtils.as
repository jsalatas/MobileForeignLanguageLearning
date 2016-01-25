package gr.ictpro.mall.client.utils.date
{
	import flash.globalization.DateTimeStyle;
	
	import mx.collections.ArrayCollection;
	import mx.core.mx_internal;
	import mx.formatters.DateBase;
	
	import spark.formatters.DateTimeFormatter;
	
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.runtime.Translation;
	
	use namespace mx_internal;

	public class DateUtils
	{
		[Bindable]
		public static var dayNames:ArrayCollection = new ArrayCollection([Translation.getTranslation('Sunday'), 
			Translation.getTranslation('Monday'), 
			Translation.getTranslation('Tuesday'), 
			Translation.getTranslation('Wednesday'), 
			Translation.getTranslation('Thusrday'), 
			Translation.getTranslation('Friday'), 
			Translation.getTranslation('Saturday')]);

		[Bindable]
		public static var shortDayNames:ArrayCollection = new ArrayCollection([Translation.getTranslation('Sunday'), 
			Translation.getTranslation('Mon'), 
			Translation.getTranslation('Tue'), 
			Translation.getTranslation('Wed'), 
			Translation.getTranslation('Thu'), 
			Translation.getTranslation('Fri'), 
			Translation.getTranslation('Sat')]);
		

		[Bindable]
		public static var monthNames:ArrayCollection = new ArrayCollection([
			Translation.getTranslation('January'), 
			Translation.getTranslation('February'), 
			Translation.getTranslation('March'), 
			Translation.getTranslation('April'), 
			Translation.getTranslation('May'), 
			Translation.getTranslation('June'), 
			Translation.getTranslation('July'), 
			Translation.getTranslation('August'), 
			Translation.getTranslation('September'), 
			Translation.getTranslation('October'), 
			Translation.getTranslation('November'), 
			Translation.getTranslation('December')]);

		private static var times:ArrayCollection = null;
		
		public static function compareNoTime(date1:Date, date2:Date):int
		{
 			if(date1.fullYear < date2.fullYear) {
				return -1;
			} else if(date1.fullYear > date2.fullYear) {
				return 1;
			} else {
				if(date1.month < date2.month) {
					return -1;
				} else if(date1.month > date2.month) {
					return 1;
				} else {
					if(date1.date < date2.date) {
						return -1;
					} else if(date1.date > date2.date) {
						return 1;
					}
				}
			}
			return 0;
		}
		
//		public function toLocalTime(date:Date):Date
//		{
//			
//		}
	
		public static function toShortDate(date:Date):String
		{
			var dtf:DateTimeFormatter = new DateTimeFormatter();
			dtf.setStyle("locale", Device.locale);
			dtf.dateStyle = DateTimeStyle.SHORT;
			dtf.timeStyle = DateTimeStyle.NONE;
			
			return dtf.format(date);
		}

		public static function toShortDateTime(date:Date):String
		{
			var dtf:DateTimeFormatter = new DateTimeFormatter();
			dtf.setStyle("locale", Device.locale);
			dtf.dateStyle = DateTimeStyle.SHORT;
			dtf.timeStyle = DateTimeStyle.SHORT;
			
			return dtf.format(date);
		}

		public static function toShortTime(date:Date):String
		{
			var dtf:DateTimeFormatter = new DateTimeFormatter();
			dtf.setStyle("locale", Device.locale);
			dtf.dateStyle = DateTimeStyle.NONE;
			dtf.timeStyle = DateTimeStyle.SHORT;
			
			return dtf.format(date);
		}

		public static function getTimesList():ArrayCollection
		{
			if(times == null) {
				times = new ArrayCollection();
				var date:Date = new Date();
				date.setHours(0, 0, 0, 0);
				times.addItem(date);
				for(var i:int=1;i<96; i++) {
					date = new Date(date);
					date.minutes += 15;
					times.addItem(date);
				}
			}
			
			return times;
		}
	}
}