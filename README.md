# Monetaria
Финансовый менеджер. 
Главные контроллеры:  

                      1- HomeViewController(Домашний экран) В нем есть список EnlargeTableView с хедером HeaderView, который содержит кнопки с переходом на AccountsViewController(Экран счетов) и TodayBalanceViewController(Экран дневного баланса),
                      2- CategoriesViewController(Экран категорий),
                      3- SchedulerViewContriller(Экран планов)
                     
Фреймворки, которые используются в проекте:

                      1- FSCalendar             - Календарь, описан в классе FSCalendarView
                      2- IQKeyboardManagerSwift - Дополнение для клавиатуры, которое смещает контент выше (будто scrollView), не давая закрыть клавиатурой textField
                      3- swiftCharts            - Диаграмма. Описание находится в папке Accounts/View/ChartContainerView/LineChart
                      4- realm                  - Фреймворк для работы с базой данных
                      