/////////////////////////////////////////////////////////////////////////////////
// <Заголовок модуля: краткое описание и условия применения модуля.>
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Получить таблицу свободных мест.
// 
// Параметры:
//  Период - Дата 
//  Ссылка -ДокументСсылка
// 
// Возвращаемое значение:
//  РезультатЗапроса, Неопределено -- Получить таблицу свободных мест
Функция ПолучитьТаблицуСвободныхМест(Период,Ссылка) Экспорт
	
	Если Не ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Период", Период);
	Запрос.УстановитьПараметр("ДокументЗаселения",Ссылка);
	
#Область ТекстЗапроса

	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗанятыеМестаОбщежитие.АдресРегистрации,
	|	ЗанятыеМестаОбщежитие.Комната,
	|	ЗанятыеМестаОбщежитие.Место
	|ПОМЕСТИТЬ Занятые
	|ИЗ
	|	РегистрСведений.ЗанятыеМестаОбщежитие КАК ЗанятыеМестаОбщежитие
	|ГДЕ
	|	ЗанятыеМестаОбщежитие.ДокументЗаселения <> &ДокументЗаселения
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	1 КАК Место
	|ПОМЕСТИТЬ ПроизвольнаяНумерация
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	2
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	3
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	4
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	5
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	6
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	7
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	8
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	9
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	10
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	11
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	12
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	13
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	14
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КомнатыВагоны.Владелец КАК АдресРегистрации,
	|	КомнатыВагоны.Ссылка КАК Комната,
	|	ПроизвольнаяНумерация.Место
	|ПОМЕСТИТЬ ВсеМеста
	|ИЗ
	|	Справочник.КомнатыВагоны КАК КомнатыВагоны
	|		ЛЕВОЕ соединение ПроизвольнаяНумерация КАК ПроизвольнаяНумерация
	|		ПО Истина
	|		И КомнатыВагоны.КоличествоМест >= Место
	|ГДЕ
	|	КомнатыВагоны.ПометкаУдаления = ЛОЖЬ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВсеМеста.АдресРегистрации,
	|	ВсеМеста.Комната,
	|	ВсеМеста.Место
	|ИЗ
	|	ВсеМеста КАК ВсеМеста
	|		ЛЕВОЕ соединение Занятые КАК Занятые
	|		ПО ВсеМеста.АдресРегистрации = Занятые.АдресРегистрации
	|		И ВсеМеста.Комната = Занятые.Комната
	|		И ВсеМеста.Место = Занятые.Место
	|Где
	|	Занятые.Место Есть NUll";
	
#КонецОбласти

	Возврат Запрос.Выполнить();
	
КонецФункции

Процедура ЗаписатьДатуВыселенияВИсториюРазмещенияСотрудников(Ссылка) Экспорт
	
	Если Не ПривилегированныйРежим() Тогда
		УстановитьПривилегированныйРежим(Истина);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка); 

#Область ТекстЗапроса

Запрос.Текст = "ВЫБРАТЬ
|	ПеремещениеСотрудниковДетальныеЗаписи.Сотрудник КАК Сотрудник,
|	ПеремещениеСотрудников.ДатаЗаселения КАК ДатаВыселения,
|	ПеремещениеСотрудников.Ссылка КАК ДокументВыселения
|ПОМЕСТИТЬ СотрудникиКВыписке
|ИЗ
|	Документ.ПеремещениеСотрудников.ДетальныеЗаписи КАК ПеремещениеСотрудниковДетальныеЗаписи
|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПеремещениеСотрудников КАК ПеремещениеСотрудников
|		ПО ПеремещениеСотрудниковДетальныеЗаписи.Ссылка = ПеремещениеСотрудников.Ссылка
|ГДЕ
|	ПеремещениеСотрудниковДетальныеЗаписи.Ссылка = &Ссылка
|
|ОБЪЕДИНИТЬ ВСЕ
|
|ВЫБРАТЬ
|	ВыселениеСотрудниковДетальныеЗаписи.Сотрудник,
|	ВыселениеСотрудников.ДатаВыселения,
|	ВыселениеСотрудников.Ссылка
|ИЗ
|	Документ.ВыселениеСотрудников.ДетальныеЗаписи КАК ВыселениеСотрудниковДетальныеЗаписи
|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВыселениеСотрудников КАК ВыселениеСотрудников
|		ПО ВыселениеСотрудниковДетальныеЗаписи.Ссылка = ВыселениеСотрудников.Ссылка
|ГДЕ
|	ВыселениеСотрудниковДетальныеЗаписи.Ссылка = &Ссылка
|
|ИНДЕКСИРОВАТЬ ПО
|	Сотрудник,
|	ДатаЗаселения
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	ИсторияРазмещенияСотрудников.Период,
|	ИсторияРазмещенияСотрудников.Регистратор,
|	ИсторияРазмещенияСотрудников.Сотрудник КАК Сотрудник,
|	ИсторияРазмещенияСотрудников.НомерСтроки
|ПОМЕСТИТЬ ИсторияСотрудника
|ИЗ
|	РегистрСведений.ИсторияРазмещенияСотрудников КАК ИсторияРазмещенияСотрудников
|		ЛЕВОЕ СОЕДИНЕНИЕ СотрудникиКВыписке КАК СотрудникиКВыписке
|		ПО ИсторияРазмещенияСотрудников.Сотрудник = СотрудникиКВыписке.Сотрудник
|		И ИсторияРазмещенияСотрудников.Период < СотрудникиКВыписке.ДатаВыселения
|
|ИНДЕКСИРОВАТЬ ПО
|	Сотрудник
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	МАКСИМУМ(ИсторияСотрудника.Период) КАК Период,
|	ИсторияСотрудника.Сотрудник КАК Сотрудник
|ПОМЕСТИТЬ ПоследниеРегистраторы
|ИЗ
|	ИсторияСотрудника КАК ИсторияСотрудника
|СГРУППИРОВАТЬ ПО
|	ИсторияСотрудника.Сотрудник
|
|ИНДЕКСИРОВАТЬ ПО
|	Сотрудник,
|	Период
|;
|
|////////////////////////////////////////////////////////////////////////////////
|ВЫБРАТЬ
|	ИсторияСотрудника.НомерСтроки КАК НомерСтроки,
|	ИсторияСотрудника.Регистратор КАК Регистратор,
|	СотрудникиКВыписке.ДатаВыселения,
|	СотрудникиКВыписке.ДокументВыселения
|ИЗ
|	ПоследниеРегистраторы КАК ПоследниеРегистраторы
|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ИсторияСотрудника КАК ИсторияСотрудника
|		ПО ИсторияСотрудника.Сотрудник = ПоследниеРегистраторы.Сотрудник
|		И ИсторияСотрудника.Период = ПоследниеРегистраторы.Период
|		ЛЕВОЕ СОЕДИНЕНИЕ СотрудникиКВыписке КАК СотрудникиКВыписке
|		ПО ИсторияСотрудника.Сотрудник = СотрудникиКВыписке.Сотрудник
|
|УПОРЯДОЧИТЬ ПО
|	НомерСтроки
|ИТОГИ
|ПО
|	Регистратор";

#КонецОбласти

	ВыборкаРегитратор = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаРегитратор.Следующий() Цикл
		НаборЗаписей = РегистрыСведений.ИсторияРазмещенияСотрудников.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Установить(ВыборкаРегитратор.Регистратор);
		НаборЗаписей.Прочитать();
		
		Выборка = ВыборкаРегитратор.Выбрать();
		Пока Выборка.Следующий() Цикл		
			НаборЗаписей[Выборка.НомерСтроки-1].ДатаВыселения 		= Выборка.ДатаВыселения;	
			НаборЗаписей[Выборка.НомерСтроки-1].ДокументВыселения 	= Выборка.ДокументВыселения;		
		КонецЦикла;
		
		НаборЗаписей.ОбменДанными.Загрузка = Истина;
		НаборЗаписей.Записать();
		
	КонецЦикла;

КонецПроцедуры

Процедура ОсвободитьЗанятыеМестаОбщежитие(Ссылка) Экспорт

	Запрос = Новый Запрос;
	Запрос.установитьпараметр("Ссылка", Ссылка);

#Область ТекстЗапроса

	Запрос.Текст = "ВЫБРАТЬ
				   |	ЗанятыеМестаОбщежитие.АдресРегистрации,
				   |	ЗанятыеМестаОбщежитие.Комната,
				   |	ЗанятыеМестаОбщежитие.Место
				   |ИЗ
				   |	РегистрСведений.ЗанятыеМестаОбщежитие КАК ЗанятыеМестаОбщежитие
				   |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ПеремещениеСотрудников.ДетальныеЗаписи КАК ПеремещениеСотрудниковДетальныеЗаписи
				   |		ПО ПеремещениеСотрудниковДетальныеЗаписи.Сотрудник = ЗанятыеМестаОбщежитие.Сотрудник
				   |ГДЕ
				   |	ПеремещениеСотрудниковДетальныеЗаписи.Ссылка = &Ссылка
				   |
				   |объединить все
				   |
				   |ВЫБРАТЬ
				   |	ЗанятыеМестаОбщежитие.АдресРегистрации,
				   |	ЗанятыеМестаОбщежитие.Комната,
				   |	ЗанятыеМестаОбщежитие.Место
				   |ИЗ
				   |	РегистрСведений.ЗанятыеМестаОбщежитие КАК ЗанятыеМестаОбщежитие
				   |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ВыселениеСотрудников.ДетальныеЗаписи КАК ВыселениеСотрудниковДетальныеЗаписи
				   |		ПО ВыселениеСотрудниковДетальныеЗаписи.Сотрудник = ЗанятыеМестаОбщежитие.Сотрудник
				   |ГДЕ
				   |	ВыселениеСотрудниковДетальныеЗаписи.Ссылка = &Ссылка";

#КонецОбласти

	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НаборЗаписей = РегистрыСведений.ЗанятыеМестаОбщежитие.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.АдресРегистрации.Установить(Выборка.АдресРегистрации);
		НаборЗаписей.Отбор.Комната.Установить(Выборка.Комната);
		НаборЗаписей.Отбор.Место.Установить(Выборка.Место);
		НаборЗаписей.Записать();
	КонецЦикла;

КонецПроцедуры

Процедура ЗафиксироватьЗанятыеМестаОбщежитие(Выборка) Экспорт
	
	Выборка.Сбросить();
	Пока Выборка.Следующий() Цикл
		
		НаборЗаписей = РегистрыСведений.ЗанятыеМестаОбщежитие.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.АдресРегистрации.Установить(Выборка.АдресРегистрации);
		НаборЗаписей.Отбор.Комната.Установить(Выборка.Комната);
		НаборЗаписей.Отбор.Место.Установить(Выборка.Место);
		
		ЗаписьРегистра = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(ЗаписьРегистра,Выборка);
		ЗаписьРегистра.ДокументЗаселения = Выборка.Регистратор;
		
		НаборЗаписей.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверкаЗаселенных(Отказ,ДетальныеЗаписи,Ссылка) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДетальныеЗаписи", 	ДетальныеЗаписи.Выгрузить());
	Запрос.УстановитьПараметр("ДокументЗаселения", 	Ссылка);

#Область ТекстЗапроса

	Запрос.Текст = "ВЫБРАТЬ
	|	ДетальныеЗаписи.Сотрудник,
	|	ДетальныеЗаписи.НомерСтроки
	|ПОМЕСТИТЬ ДетальныеЗаписи
	|ИЗ
	|	&ДетальныеЗаписи КАК ДетальныеЗаписи
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Представление(ЗанятыеМестаОбщежитие.Сотрудник) КАК Сотрудник,
	|	ДетальныеЗаписи.НомерСтроки КАК НомерСтроки
	|ИЗ
	|	ДетальныеЗаписи КАК ДетальныеЗаписи
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЗанятыеМестаОбщежитие КАК ЗанятыеМестаОбщежитие
	|		ПО ДетальныеЗаписи.Сотрудник = ЗанятыеМестаОбщежитие.Сотрудник
	|		
	|ГДЕ
	|	ЗанятыеМестаОбщежитие.Сотрудник ЕСТЬ NULL И ЗанятыеМестаОбщежитие.ДокументЗаселения <> &ДокументЗаселения
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";

#КонецОбласти

	Результат =Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;

	Массив = Новый Массив;
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл

		Массив.Добавить(СтрШаблон("стр.%1 %2 не найдено размещение", Выборка.НомерСтроки, 
														Выборка.Сотрудник));
	КонецЦикла;

	ОбщегоНазначения.СообщитьПользователю(СтрСоединить(Массив, Символы.ПС), , , , Отказ);

КонецПроцедуры


Функция ПолучитьСтоимостьПоПриказу(АдресРегистрации) Экспорт
		
		Запрос = Новый Запрос; 
		Запрос.УстановитьПараметр(АдресРегистрации,АдресРегистрации);
#Область ТекстЗапроса
	Запрос.Текст = "ВЫБРАТЬ
	|	СтоимостьПроживанияВОбщежитииСрезПоследних.АдресРегистрации,
	|	СтоимостьПроживанияВОбщежитииСрезПоследних.Стоимость
	|ИЗ
	|	РегистрСведений.СтоимостьПроживанияВОбщежитии.СрезПоследних(, АдресРегистрации = &АдресРегистрации) КАК
	|		СтоимостьПроживанияВОбщежитииСрезПоследних";
#КонецОбласти
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Стоимость
	КонецЕсли;  

	Возврат 0;
	
КонецФункции
#КонецОбласти