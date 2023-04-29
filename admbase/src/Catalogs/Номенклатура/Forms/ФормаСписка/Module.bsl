////////////////////////////////////////////////////////////////////////////////
// <Заголовок модуля: краткое описание и условия применения модуля.>
//  
////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьОтборыСпикаНоменклатуры();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СостояниеПриИзменении(Элемент) 
	
	УстановитьОтборыСпикаНоменклатуры();

КонецПроцедуры
	
	
#КонецОбласти 

#Область ОбработчикиСобытийЭлементовТаблицыФормыИерархияНоменклатуры

&НаКлиенте
Процедура ИерархияНоменклатурыПриАктивизацииСтроки(Элемент)
	
	УстановитьОтборыСпикаНоменклатуры(); 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьОтборыСпикаНоменклатуры()
	
	Список.Отбор.Элементы.Очистить();

	ТекущиеДанные = Элементы.ИерархияНоменклатуры.ТекущиеДанные;

	Если Не ТекущиеДанные = Неопределено Тогда
		
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Родитель");
		ЭлементОтбора.ВидСравнения 	= ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение = ТекущиеДанные.Ссылка;
		
	КонецЕсли;
	
	Если Не Состояние.Пустая() Тогда
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Состояние");
		ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.ПравоеЗначение = Состояние;
		
	КонецЕсли;  
	
КонецПроцедуры


#КонецОбласти
