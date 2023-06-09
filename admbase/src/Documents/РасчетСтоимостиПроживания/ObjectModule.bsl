////////////////////////////////////////////////////////////////////////////////
// <Заголовок модуля: краткое описание и условия применения модуля.>
//  
////////////////////////////////////////////////////////////////////////////////
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка",Ссылка); 
	
#Область ТекстЗапроса
	Запрос.Текст = "ВЫБРАТЬ
	|	РасчетСтоимостиПроживания.Ссылка КАК Регистратор,
	|	РасчетСтоимостиПроживания.ПериодРасчета КАК Период,
	|	РасчетСтоимостиПроживанияДетальныеЗаписи.Сотрудник,
	|	РасчетСтоимостиПроживанияДетальныеЗаписи.АдресРегистрации,
	|	РасчетСтоимостиПроживанияДетальныеЗаписи.Комната,
	|	РасчетСтоимостиПроживанияДетальныеЗаписи.Место,
	|	РасчетСтоимостиПроживанияДетальныеЗаписи.Стоимость,
	|	РасчетСтоимостиПроживанияДетальныеЗаписи.Всего КАК Сумма,
	|	РасчетСтоимостиПроживанияДетальныеЗаписи.КоличествоДней КАК Количество,
	|	РасчетСтоимостиПроживанияДетальныеЗаписи.ДатаНачала,
	|	РасчетСтоимостиПроживанияДетальныеЗаписи.ДатаОкончания
	|ИЗ
	|	Документ.РасчетСтоимостиПроживания.ДетальныеЗаписи КАК РасчетСтоимостиПроживанияДетальныеЗаписи
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РасчетСтоимостиПроживания КАК РасчетСтоимостиПроживания
	|		ПО РасчетСтоимостиПроживанияДетальныеЗаписи.Ссылка = РасчетСтоимостиПроживания.Ссылка
	|ГДЕ
	|	РасчетСтоимостиПроживанияДетальныеЗаписи.Ссылка = &Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	РасчетСтоимостиПроживанияДетальныеЗаписи.НомерСтроки";
#КонецОбласти
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ЗаполнитьЗначенияСвойств(Движения.СтоимостьПроживанияСотрудников.Добавить(),Выборка);
	КонецЦикла;

	Движения.СтоимостьПроживанияСотрудников.Записывать = Истина;

КонецПроцедуры

#КонецОбласти

#КонецЕсли


