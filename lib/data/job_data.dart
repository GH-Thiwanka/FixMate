import 'package:fixmate/model/job_model.dart';

class MyJobsData {
  static final List<JobModel> jobs = [
    // --- 1. ACTIVE JOBS ---
    const JobModel(
      id: 'JOB-84920',
      title: 'Full Room Painting',
      category: 'Painting',
      serviceIcon: 'assets/icons/paint.svg',
      status: JobStatus.workerOnTheWay,
      statusText: 'Worker on the Way',
      dateTime: 'Today, 2:30 PM',
      address: 'Colombo 07, Sri Lanka',
      price: 18000,
      workerName: 'Sunil Perera',
      workerAvatar:
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      workerRating: 4.8,
      tab: JobTabType.active,
    ),
    const JobModel(
      id: 'JOB-84919',
      title: 'AC Gas Refill & Cleaning',
      category: 'AC Repair',
      serviceIcon: 'assets/icons/air.svg',
      status: JobStatus.quoteReceived,
      statusText: '3 Quotes Received',
      dateTime: 'Requested: Today, 11:00 AM',
      address: 'Colombo 03, Kollupitiya',
      quoteCount: 3,
      tab: JobTabType.active,
    ),

    // --- 2. UPCOMING JOBS ---
    const JobModel(
      id: 'JOB-84915',
      title: 'Pipe Leak Repair & Tap Fix',
      category: 'Plumbing',
      serviceIcon: 'assets/icons/plumb.svg',
      status: JobStatus.confirmed,
      statusText: 'Booking Confirmed',
      dateTime: 'Tomorrow, 9:00 AM - 12:00 PM',
      address: 'No. 24, Dehiwala',
      price: 6500,
      workerName: 'Kasun Fernando',
      workerAvatar:
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
      workerRating: 4.9,
      tab: JobTabType.upcoming,
    ),

    // --- 3. COMPLETED JOBS ---
    const JobModel(
      id: 'JOB-84801',
      title: 'Ceiling Fan & Switch Repair',
      category: 'Electrical',
      serviceIcon: 'assets/icons/light.svg',
      status: JobStatus.completed,
      statusText: 'Completed',
      dateTime: 'Aug 28, 2026',
      address: 'Colombo 07, Sri Lanka',
      price: 4500,
      workerName: 'Nimal Jayasuriya',
      workerAvatar:
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
      workerRating: 5.0,
      tab: JobTabType.completed,
    ),

    // --- 4. CANCELLED JOBS ---
    const JobModel(
      id: 'JOB-84722',
      title: 'Door Lock Replacement',
      category: 'Carpentry',
      serviceIcon: 'assets/icons/saw.svg',
      status: JobStatus.cancelled,
      statusText: 'Cancelled',
      dateTime: 'Aug 20, 2026',
      address: 'Rajagiriya, Colombo',
      price: 3200,
      tab: JobTabType.cancelled,
    ),
  ];
}
