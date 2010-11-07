package
{
	
import com.golfzon.gfl.core.ComponentBase;

public class ComponentBaseSample extends ComponentBase
{
	public function ComponentBaseSample() {
		super();
	}
	
	override protected function commitProperties():void {
		super.commitProperties();
		
		// TODO : 프로퍼티 변경 사항에 대한 처리
	}
	
	override protected function createChildren():void {
		// TODO : 자식 객체 생성 및 추가
	}
	
	override protected function measure():void {
		super.measure();
		
		// TODO : 컴퍼넌트의 기본 크기와 최소 크기를 설정한다.
		
		measureWidth = 100;
		measureHeight = 100;
		
		// width와 height를 unscaledWidth와 unscaledHeight로 설정한다.
		setActureSize(unscaledWidth, unscaledHeight);
	}

	override protected function setStateToChangeEnabled():void {
		super.setStateToChangeEnabled();
		
		// TODO : enabled 변경 사항에 대한 처리를 구현한다.
	}
	
	override public function styleChanged(styleProp:String):void {
		super.styleChanged(styleProp);
		
		// TODO : 스타일 변경에 대한 처리
	}
	
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		// TODO : 디스플레이 변경 사항에 대한 처리
	}
}

}