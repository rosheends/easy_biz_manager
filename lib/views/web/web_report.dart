import 'package:easy_biz_manager/services/dashboard_service.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class ReportPage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ReportPage({Key? key}) : super(key: key);

  @override
  ReportPageState createState() => ReportPageState();
}

class ReportPageState extends State<ReportPage> {

  DashboardService dashboardService = DashboardService();

  List<_BudgetData> budgetData = [];

  List<_PieData> projectByType = [];
  List<_PieData> projectByResources = [];
  List<_PieData> projectByInvoices = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    List<dynamic> temp = (await dashboardService.getExpenses());
    dynamic projectTypes = {};
    dynamic resourceTypes = {};
    dynamic invoiceByStatus = {};

    for(dynamic item in temp){
      print(item);
      budgetData.add(new _BudgetData(item["project_code"], double.parse(item["budget"])));

      if(projectTypes[item["product_code"]] != null){
        projectTypes[item["product_code"]] = projectTypes[item["product_code"]] + 1;
      } else {
        projectTypes[item["product_code"]] = 1;
      }

      for(dynamic user in item["users"] ){
        if(resourceTypes[user["role"]] != null){
          resourceTypes[user["role"]] = resourceTypes[user["role"]] + 1;
        } else {
          resourceTypes[user["role"]] = 1;
        }
      }

      for(dynamic invoice in item["invoices"] ){
        if(invoiceByStatus[invoice["payment_status"]] != null){
          invoiceByStatus[invoice["payment_status"]] = invoiceByStatus[invoice["payment_status"]] + 1;
        } else {
          invoiceByStatus[invoice["payment_status"]] = 1;
        }
      }
    }

    projectTypes.forEach((k,v) => {
      projectByType.add(new _PieData(k,v,v.toString()))
    });

    resourceTypes.forEach((k,v) => {
      projectByResources.add(new _PieData(k,v,v.toString()))
    });

    invoiceByStatus.forEach((k,v) => {
      projectByInvoices.add(new _PieData(k,v,v.toString()))
    });

    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Overall Report'),
        ),
        body: Column(children: [
          //Initialize the chart widget
          SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              title: ChartTitle(text: 'Project vs Budget'),
              // Enable legend
              legend: Legend(isVisible: false),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<_BudgetData, String>>[
                LineSeries<_BudgetData, String>(
                    dataSource: budgetData,
                    xValueMapper: (_BudgetData budget, _) => budget.projectCode,
                    yValueMapper: (_BudgetData budget, _) => budget.budget,
                    name: 'Project Code',
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true))
              ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SfCircularChart(
                  title: ChartTitle(text: 'Projects by Type'),
                  legend: Legend(isVisible: true),
                  series: <PieSeries<_PieData, String>>[
                    PieSeries<_PieData, String>(
                        explode: true,
                        explodeIndex: 0,
                        dataSource: projectByType,
                        xValueMapper: (_PieData data, _) => data.xData,
                        yValueMapper: (_PieData data, _) => data.yData,
                        dataLabelMapper: (_PieData data, _) => data.text,
                        dataLabelSettings: DataLabelSettings(isVisible: true)),
                  ]
              ),
              SfCircularChart(
                  title: ChartTitle(text: 'Resources by Type'),
                  legend: Legend(isVisible: true),
                  series: <PieSeries<_PieData, String>>[
                    PieSeries<_PieData, String>(
                        explode: true,
                        explodeIndex: 0,
                        dataSource: projectByResources,
                        xValueMapper: (_PieData data, _) => data.xData,
                        yValueMapper: (_PieData data, _) => data.yData,
                        dataLabelMapper: (_PieData data, _) => data.text,
                        dataLabelSettings: DataLabelSettings(isVisible: true)),
                  ]
              ),
              SfCircularChart(
                  title: ChartTitle(text: 'Invoices by Status'),
                  legend: Legend(isVisible: true),
                  series: <PieSeries<_PieData, String>>[
                    PieSeries<_PieData, String>(
                        explode: true,
                        explodeIndex: 0,
                        dataSource: projectByInvoices,
                        xValueMapper: (_PieData data, _) => data.xData,
                        yValueMapper: (_PieData data, _) => data.yData,
                        dataLabelMapper: (_PieData data, _) => data.text,
                        dataLabelSettings: DataLabelSettings(isVisible: true)),
                  ]
              )
            ],
          )
        ]));
  }
}

class _BudgetData {
  _BudgetData(this.projectCode, this.budget);

  final String projectCode;
  final double budget;
}

class _PieData {
  _PieData(this.xData, this.yData, this.text);
  final String xData;
  final num yData;
  final String text;
}