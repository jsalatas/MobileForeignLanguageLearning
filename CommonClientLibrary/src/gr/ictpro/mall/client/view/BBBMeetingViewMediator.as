package gr.ictpro.mall.client.view
{
	public class BBBMeetingViewMediator extends TopBarCollaborationViewMediator
	{
		override public function onRegister():void
		{
			super.onRegister();
			
			trace("joining meeting: " + view.parameters.vo.id);
		}
	}
}