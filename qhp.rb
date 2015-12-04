require 'Qt'
require "./basehoney.rb"

class MyWidget < Qt::Widget
    slots 'onStartClicked()'
    slots 'onStopclicked()'
	def initialize
		super
		create
	end

	def create
		self.setWindowTitle("QT Honey")
		self.setGeometry(300, 300, 250, 150)
		self.setToolTip("Simple Widget")
		layout = Qt::VBoxLayout.new
		@btnClickMe = Qt::PushButton.new("Run")
		@lblText = Qt::Label.new("not running..")
    @btnClickMe2 = Qt::PushButton.new("Stop")
		connect(@btnClickMe, SIGNAL("clicked()"), SLOT("onStartClicked()"))
    connect(@btnClickMe2, SIGNAL("clicked()"), SLOT("onStopclicked()"))
		layout.addWidget(@btnClickMe)
    layout.addWidget(@btnClickMe2)
    layout.addWidget(@lblText)
		setLayout(layout)
	end

  def onStopclicked
			@lblText.setText("not running..")
      @honey.kill unless @honey.nil?
      p "stop"
  end

	def onStartClicked
		subWindow = SubWindow.new

		case subWindow.exec()
		when 1
			str = subWindow.getStr()
			@lblText.setText("running:"+str)
      p "start"
      @honey = Thread.new {
           run(str.to_i)
       }

		when 0
			p "stop"
		end
	end
end

class SubWindow < Qt::Dialog
	def initialize
		super
		create
	end
	def create
		setWindowTitle("ポート番号")
		vlay = Qt::VBoxLayout.new
		@Ok = Qt::PushButton.new("ﾊﾆｰﾌﾗｯｼｭ")
		@Cancel = Qt::PushButton.new("ｷｬﾝｾﾙ")
		@portaddr = Qt::LineEdit.new("2345")
		connect(@Ok, SIGNAL("clicked()"), self, SLOT("accept()"))
		connect(@Cancel, SIGNAL("clicked()"), self, SLOT("reject()"))
    vlay.addWidget(@portaddr)
		vlay.addWidget(@Ok)
		vlay.addWidget(@Cancel)
		setLayout(vlay)

	end
	def getStr()
		return @portaddr.text
	end
end

app = Qt::Application.new(ARGV)
window = MyWidget.new
window.show

app.exec
