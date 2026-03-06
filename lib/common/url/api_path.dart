class ApiPath {
  //AUTH
  static String login = '/api/v1/auth/login';
  static String google = '/api/v1/auth/google';
  static String logout = '/api/v1/auth/logout';
  static String changePassword = '/api/v1/auth/update-password';

  //SUBMISSION
  static String submissions = '/api/v1/submissions';
  static String submissionLeaveTypes = '/api/v1/submission/leaves/types';
  static String submissionLeaveRequests = '/api/v1/submission/leaves/requests';
  // static String submissionLeavesApprovals = '/api/v1/submission/leaves/approvals';
  static String submissionLeaveBalance = '/api/v1/submission/leaves/balance';
  static String submissionTotalDays =
      '/api/v1/submission/leaves/requests/calculate-days';
  static String submissionOvertimes = '/api/v1/submission/overtimes';
  static String submissionOvertimesStatus =
      '/api/v1/submission/overtimes/status';
  static String submissionProcurement = '/api/v1/submission/procurement';
  static String submissionUsage = '/api/v1/submission/usage';
  static String submissionLoan = '/api/v1/submission/loan';
  static String submissionAttendanceCorrections =
      '/api/v1/submission/attendance-corrections';
  // static String submissionGeneral = '/api/v1/submission/general';
  // static String submissionReceivablesLoan = '/api/v1/receivables/history';

  //CHECKLIST
  static String checklist = '/api/v1/checklists';
  static String checklistCategory = '/api/v1/checklist-categories';

  //DEPARTMENT
  static String department = '/api/v1/departments';
  static String departmentById(int id) => '/api/v1/departments/$id';

  //EMPLOYEE
  static String employee = '/api/v1/employees';

  //PERFORMANCE
  static String performance = '/api/v1/performances';

  //ITEM
  static String item = '/api/v1/items';

  //VEHICLE
  static String vehicle = '/api/v1/vehicles';

  //BRANCH
  static String branch = '/api/v1/branchs';
  static String listBranch = '/api/v1/branchs/list-branch';

  //FINANCIAL
  static String financialInformation = '/api/v1/financialinformations';

  //REPORT
  static String report = '/api/v1/reports';

  //REPORT COMMENT
  static String reportComment(int reportId) =>
      '/api/v1/reports/$reportId/comments';

  //PROFILE
  static String profile = '/api/v1/profile';
  static String profileById(int id) => '/api/v1/profile/$id';

  //INVENTORY
  static String inventory = '/api/v1/items';
  static String inventoryStockHistory = '/api/v1/item-stocks/history';

  //INSPECTION
  static String inspection = '/api/v1/inspections';
  static String inspectionGroup = '/api/v1/inspections/group';
  static String inspectionChecklistDraft =
      '/api/v1/inspections/checklist/draft';
  static String inspectionHistory = '/api/v1/inspections/history';

  // UPLOAD
  static String uploadSingle = '/api/v1/upload/single';

  static String workPrinciplePrinciple = '/api/v1/work-principles/prinsip';
  static String workPrincipleEthic = '/api/v1/work-principles/etos-kerja';

  //ABSENT
  static String attendanceEmployeeBarcode =
      '/api/v1/attendance-employee-barcode';
  static String attendanceHit = '/api/v1/attendances/hit';
  static String attendanceHistory = '/api/v1/attendances/history';
  static String attendanceLog = '/api/v1/attendances/log';

  //NOTIFICATION
  static String notificationHistory = '/api/v1/notifications/history';
  static String notification = '/api/v1/notifications';

  //Reimbursement
  static String reimbursement = '/api/v1/reimbursements';

  //Payslip
  static String payslip = '/api/v1/salary-slips';

  //ANNOUNCEMENT
  static String announcement = '/api/v1/announcements';

  //Payslip
  static String calendar = '/api/v1/calendar';

  //Payslip
  static String updateKilometer = '/api/v1/vehicle-odometers';

  //Stock
  static String stock = '/api/v1/stocks';
  static String stockRecap = '/api/v1/stocks/recap';
  static String stockUpdate = '/api/v1/stocks/update';

  //Shift
  static String shiftWork = '/api/v1/shift-works';

  //Shift
  static String compliance = '/api/v1/compliances';
}
