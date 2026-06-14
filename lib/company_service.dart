import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CompanyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<Map<String, dynamic>> companiesData = [
    {
      'name': 'AMD',
      'industry': 'Semiconductor & Computing Technology',
      'location': 'Penang',
      'positions': ['Software Development Intern', 'Hardware Validation Intern', 'Semiconductor Engineering Intern', 'AI Technologies Intern', 'Data Analytics Intern', 'Business Operations Intern'],
      'description': 'AMD (Advanced Micro Devices) is a global leader in high-performance computing, graphics, and visualization technologies. The company designs and manufactures innovative microprocessors and GPUs that power millions of intelligent devices, from personal computers and game consoles to the world\'s most powerful supercomputers. In Malaysia, AMD operates a significant engineering and global operations hub.',
      'rating': '4.8',
      'imagePath': 'asset/image/AMD.png',
      'bannerPath': 'asset/image/company/amd company.jpg',
      'allowance': 'RM1,500 - RM2,000',
      'reviews': [
        {'user': 'Alex T.', 'rating': 5.0, 'comment': 'Amazing culture and cutting-edge technology. The mentors are top-notch!', 'isVerified': true},
        {'user': 'Sarah K.', 'rating': 4.5, 'comment': 'Great place to learn about semiconductor design. Highly recommended.', 'isSample': false},
        {'user': 'Haris M.', 'rating': 4.0, 'comment': 'Very systematic training module and professional environment.', 'isSample': true}
      ]
    },
    {
      'name': 'Accenture Malaysia',
      'industry': 'IT Consulting & Professional Services',
      'location': 'Kuala Lumpur',
      'positions': ['Project Management Intern', 'Software Engineering Intern', 'Data Analytics Intern', 'Cloud Technologies Intern', 'Consulting Intern'],
      'description': 'Accenture is a leading global professional services company, providing a broad range of services and solutions in strategy, consulting, digital, technology, and operations. Combining unmatched experience and specialized skills across more than 40 industries, Accenture works at the intersection of business and technology to help clients improve their performance and create sustainable value for their stakeholders.',
      'rating': '4.6',
      'imagePath': 'asset/image/Accenture.png',
      'bannerPath': 'asset/image/company/accenture company.webp',
      'allowance': 'RM1,200 - RM1,600',
      'reviews': [
        {'user': 'Jason L.', 'rating': 4.0, 'comment': 'Fast-paced environment but learned a lot about project management.', 'isSample': true},
        {'user': 'Michelle W.', 'rating': 5.0, 'comment': 'Incredible networking opportunities and professional growth.', 'isSample': true}
      ]
    },
    {
      'name': 'Apple',
      'industry': 'Consumer Electronics & Technology',
      'location': 'Kuala Lumpur',
      'positions': ['Software Engineering Intern', 'Machine Learning Intern', 'Operations Intern', 'Supply Chain Management Intern', 'Marketing Intern', 'Business Analysis Intern'],
      'description': 'Apple is a global pioneer in consumer technology, renowned for its innovation in hardware, software, and services. From the iPhone and Mac to the Apple Watch and specialized AI services, Apple focuses on creating products that empower people and enrich their lives. The Malaysia office supports various regional operations and strategic initiatives.',
      'rating': '4.9',
      'imagePath': 'asset/image/apple.png',
      'bannerPath': 'asset/image/company/apple company.jpg',
      'allowance': 'RM2,000 - RM3,000',
      'reviews': [
        {'user': 'David R.', 'rating': 5.0, 'comment': 'An unparalleled experience. You get to work on products used by millions.', 'isSample': true},
        {'user': 'Emily C.', 'rating': 4.8, 'comment': 'High standards but extremely rewarding work environment.', 'isSample': true}
      ]
    },
    {
      'name': 'Axiata Group',
      'industry': 'Telecommunications',
      'location': 'Kuala Lumpur',
      'positions': ['Telecom Engineering Intern', 'Digital Product Development Intern', 'Finance Intern', 'Business Strategy Intern'],
      'description': 'Axiata is one of the leading telecommunications groups in Asia, with a mission to advance Asia through connectivity, technology, and talent. With a presence in over 10 countries, Axiata is committed to driving digital transformation and providing innovative services in mobile connectivity, digital business, and infrastructure.',
      'rating': '4.7',
      'imagePath': 'asset/image/axiata-seeklogo.png',
      'bannerPath': 'asset/image/company/axiata group company.jpg',
      'allowance': 'RM1,200 - RM1,600',
      'reviews': [
        {'user': 'Zul H.', 'rating': 4.5, 'comment': 'Very supportive team and great exposure to regional telecom trends.', 'isSample': true},
        {'user': 'Lina M.', 'rating': 4.7, 'comment': 'Loved the digital-first culture here.', 'isSample': true}
      ]
    },
    {
      'name': 'Bosch Malaysia',
      'industry': 'Engineering & Manufacturing',
      'location': 'Penang',
      'positions': ['Mechanical Engineering Intern', 'Software Development Intern', 'Embedded Systems Intern', 'Industrial Automation Intern', 'Supply Chain Management Intern'],
      'description': 'Bosch is a world-class engineering and technology provider, operating across four business sectors: Mobility Solutions, Industrial Technology, Consumer Goods, and Energy and Building Technology. Bosch Malaysia is a key part of this global network, specializing in manufacturing and R&D that supports the future of automated and sustainable living.',
      'rating': '4.6',
      'imagePath': 'asset/image/bosch-logo-39988.png',
      'bannerPath': 'asset/image/company/bosch malaysia company.jpg',
      'allowance': 'RM1,000 - RM1,500',
      'reviews': [
        {'user': 'Kevin S.', 'rating': 4.2, 'comment': 'Great for hands-on engineering experience.', 'isSample': true},
        {'user': 'Amir A.', 'rating': 4.8, 'comment': 'Learned so much about industrial IoT and automation.', 'isSample': true}
      ]
    },
    {
      'name': 'CIMB Bank',
      'industry': 'Banking & Financial Services',
      'location': 'Kuala Lumpur',
      'positions': ['Financial Analysis Intern', 'Risk Management Intern', 'Digital Banking Intern', 'Cybersecurity Intern', 'Customer Relationship Management Intern'],
      'description': 'CIMB Group is a leading focused ASEAN universal bank and one of the region’s foremost corporate advisors. It is also a world leader in Islamic finance. CIMB is dedicated to providing innovative financial products and services that meet the needs of individuals, businesses, and large corporations across the Southeast Asian market.',
      'rating': '4.4',
      'imagePath': 'asset/image/cimb.webp',
      'bannerPath': 'asset/image/company/cimb bank company.jpg',
      'allowance': 'RM800 - RM1,000',
      'reviews': [
        {'user': 'Tan Y.', 'rating': 4.0, 'comment': 'Good introduction to the banking industry.', 'isSample': true},
        {'user': 'Sofia B.', 'rating': 4.5, 'comment': 'Strong emphasis on digital banking and innovation.', 'isSample': true}
      ]
    },
    {
      'name': 'Carsome',
      'industry': 'Automotive E-Commerce',
      'location': 'Petaling Jaya, Selangor',
      'positions': ['Software Engineering Intern', 'Product Management Intern', 'Business Intelligence Intern', 'Digital Marketing Intern', 'Operations Intern'],
      'description': 'Carsome is Southeast Asia’s largest integrated car e-commerce platform, offering end-to-end solutions for consumers and used car dealers. From car inspection to ownership transfer and financing, Carsome uses technology to simplify the car buying and selling process, ensuring trust, transparency, and efficiency.',
      'rating': '4.7',
      'imagePath': 'asset/image/CARSOME_Logo_Black_With_Sy_Bg.webp',
      'bannerPath': 'asset/image/company/Carsome company.jpeg',
      'allowance': 'RM1,000 - RM1,500',
      'reviews': [
        {'user': 'Ryan K.', 'rating': 4.6, 'comment': 'Fast-paced startup vibe. Lots of responsibility from day one.', 'isSample': true},
        {'user': 'Grace T.', 'rating': 4.8, 'comment': 'Amazing data-driven culture.', 'isSample': true}
      ]
    },
    {
      'name': 'CelcomDigi',
      'industry': 'Telecommunications',
      'location': 'Petaling Jaya, Selangor',
      'positions': ['Network Engineering Intern', 'Software Development Intern', 'Data Analytics Intern', 'Digital Marketing Intern', 'Customer Experience Management Intern'],
      'description': 'CelcomDigi is Malaysia’s largest mobile network operator, created through the merger of two iconic telecommunications giants. The company is committed to providing superior network experiences and innovative digital solutions to millions of Malaysians, driving the nation’s digital ambitions forward.',
      'rating': '4.6',
      'imagePath': 'asset/image/CelcomDigi.png',
      'bannerPath': 'asset/image/company/celcomdigi company.jpg',
      'allowance': 'RM1,000 - RM1,300',
      'reviews': [
        {'user': 'Ibrahim O.', 'rating': 4.4, 'comment': 'Great team spirit during the merger transition.', 'isSample': true},
        {'user': 'Lim J.', 'rating': 4.7, 'comment': 'Modern office and helpful colleagues.', 'isSample': true}
      ]
    },
    {
      'name': 'Dell Technologies Malaysia',
      'industry': 'Information Technology',
      'location': 'Cyberjaya, Selangor',
      'positions': ['Software Engineering Intern', 'IT Infrastructure Intern', 'Cloud Computing Intern', 'Technical Support Intern', 'Business Operations Intern'],
      'description': 'Dell Technologies is a unique family of businesses that provides the address the essential infrastructure for organizations to build their digital future, transform IT, and protect their most important asset—information. Dell Malaysia serves as a global hub for technical support, financial services, and manufacturing operations.',
      'rating': '4.7',
      'imagePath': 'asset/image/dell-seeklogo.png',
      'bannerPath': 'asset/image/company/Dell technologies malaysia company.webp',
      'allowance': 'RM1,000 - RM1,400',
      'reviews': [
        {'user': 'Chris N.', 'rating': 4.5, 'comment': 'Flexible working arrangements and good mentorship.', 'isSample': true},
        {'user': 'Maya P.', 'rating': 4.8, 'comment': 'Cutting-edge tech and a very inclusive environment.', 'isSample': true}
      ]
    },
    {
      'name': 'Deloitte Malaysia',
      'industry': 'Professional Services',
      'location': 'Kuala Lumpur',
      'positions': ['Audit Intern', 'Consulting Intern', 'Financial Analysis Intern', 'Digital Transformation Intern'],
      'description': 'Deloitte is a global leader in audit and assurance, consulting, financial advisory, risk advisory, tax, and related services. With a network of member firms in more than 150 countries, Deloitte brings world-class capabilities and high-quality service to clients, delivering the insights they need to address their most complex business challenges.',
      'rating': '4.5',
      'imagePath': 'asset/image/Deloitte.webp',
      'bannerPath': 'asset/image/company/deloitte malaysia company.jpg',
      'allowance': 'RM1,000 - RM1,200',
      'reviews': [
        {'user': 'Wong H.', 'rating': 4.3, 'comment': 'Demanding but very rewarding. Excellent for your CV.', 'isSample': true},
        {'user': 'Nadia R.', 'rating': 4.7, 'comment': 'Professional development is prioritized here.', 'isSample': true}
      ]
    },
    {
      'name': 'EY Malaysia (Ernst & Young)',
      'industry': 'Professional Services',
      'location': 'Kuala Lumpur',
      'positions': ['Auditing Intern', 'Taxation Intern', 'Consulting Intern', 'Technology Risk Intern', 'Business Advisory Intern'],
      'description': 'EY is a global leader in assurance, tax, consulting, strategy, and transactions. The insights and quality services we deliver help build trust and confidence in the capital markets and in economies the world over. EY Malaysia is dedicated to building a better working world for our people, our clients, and our communities.',
      'rating': '4.5',
      'imagePath': 'asset/image/EY Malaysia.png',
      'bannerPath': 'asset/image/company/EY malaysia (ernst & young) company.jpg',
      'allowance': 'RM1,000 - RM1,200',
      'reviews': [
        {'user': 'Siva M.', 'rating': 4.5, 'comment': 'Great learning curve and supportive audit teams.', 'isSample': true},
        {'user': 'Tan L.', 'rating': 4.4, 'comment': 'Excellent training programs for interns.', 'isSample': true}
      ]
    },
    {
      'name': 'Google',
      'industry': 'Technology & Internet Services',
      'location': 'Kuala Lumpur',
      'positions': ['Software Development Intern', 'AI Research Intern', 'Product Management Intern', 'UX Design Intern', 'Cloud Technologies Intern'],
      'description': 'Google’s mission is to organize the world’s information and make it universally accessible and useful. Google Malaysia supports the digital ecosystem through search, advertising, cloud computing, and hardware initiatives. It is a place where employees can innovate and build products that impact billions of people worldwide.',
      'rating': '4.9',
      'imagePath': 'asset/image/google.png',
      'bannerPath': 'asset/image/company/google company.jpg',
      'allowance': 'RM2,000 - RM3,000',
      'reviews': [
        {'user': 'Avery G.', 'rating': 5.0, 'comment': 'Free food and amazing projects. What more can you ask for?', 'isSample': true},
        {'user': 'Leo X.', 'rating': 4.9, 'comment': 'Smartest people I have ever worked with.', 'isSample': true}
      ]
    },
    {
      'name': 'Grab',
      'industry': 'Technology & Digital Services',
      'location': 'Petaling Jaya, Selangor',
      'positions': ['Software Engineering Intern', 'Data Science Intern', 'Business Development Intern', 'Product Management Intern'],
      'description': 'Grab is Southeast Asia’s leading super app, providing everyday services such as ride-hailing, food delivery, and digital payments. Grab’s mission is to drive Southeast Asia forward by creating economic empowerment for everyone. The company leverages data and technology to solve regional challenges and improve millions of lives.',
      'rating': '4.6',
      'imagePath': 'asset/image/grab.png',
      'bannerPath': 'asset/image/company/grab company.jpeg',
      'allowance': 'RM1,000 - RM1,500',
      'reviews': [
        {'user': 'Hisham D.', 'rating': 4.7, 'comment': 'Dynamic environment and real impact on local communities.', 'isSample': true},
        {'user': 'Chandra P.', 'rating': 4.5, 'comment': 'Learned a lot about product scalability.', 'isSample': true}
      ]
    },
    {
      'name': 'HSBC Malaysia',
      'industry': 'Banking & Financial Services',
      'location': 'Kuala Lumpur',
      'positions': ['Banking Operations Intern', 'Financial Markets Intern', 'Compliance Intern', 'Risk Management Intern', 'Digital Banking Intern'],
      'description': 'HSBC is one of the world’s largest banking and financial services organizations. HSBC Malaysia offers a comprehensive range of financial services including retail, commercial, and investment banking. The bank is committed to opening up a world of opportunity for its customers and employees in the region.',
      'rating': '4.5',
      'imagePath': 'asset/image/HSBC.png',
      'bannerPath': 'asset/image/company/hsbc malaysia company.png',
      'allowance': 'RM1,000 - RM1,400',
      'reviews': [
        {'user': 'Farhan Q.', 'rating': 4.2, 'comment': 'Structured internship program and professional atmosphere.', 'isSample': true},
        {'user': 'Lucy W.', 'rating': 4.6, 'comment': 'Global perspective on financial markets.', 'isSample': true}
      ]
    },
    {
      'name': 'Honeywell Malaysia',
      'industry': 'Industrial Technology',
      'location': 'Kuala Lumpur',
      'positions': ['Engineering Intern', 'Automation Systems Intern', 'Software Development Intern', 'Project Management Intern'],
      'description': 'Honeywell is a Fortune 100 technology company that delivers industry-specific solutions that include aerospace products and services; control technologies for buildings and industry; and performance materials globally. Honeywell Malaysia supports the region through advanced engineering and technical services.',
      'rating': '4.6',
      'imagePath': 'asset/image/Honeywell.png',
      'bannerPath': 'asset/image/company/honeywell malaysia company.jpg',
      'allowance': 'RM1,000 - RM1,500',
      'reviews': [
        {'user': 'Ramesh T.', 'rating': 4.5, 'comment': 'Great exposure to aerospace and control systems.', 'isSample': true},
        {'user': 'Siti N.', 'rating': 4.4, 'comment': 'Technical expertise of the mentors is impressive.', 'isSample': true}
      ]
    },
    {
      'name': 'IBM Malaysia',
      'industry': 'Information Technology',
      'location': 'Petaling Jaya, Selangor',
      'positions': ['Software Development Intern', 'AI Projects Intern', 'Consulting Intern', 'Cloud Technology Intern'],
      'description': 'IBM is a global technology and innovation company headquartered in Armonk, NY. It is the largest technology and consulting employer in the world, serving clients in 170 countries. IBM Malaysia is a hub for cloud, AI, and enterprise services, helping businesses transform through technology.',
      'rating': '4.6',
      'imagePath': 'asset/image/IBM.png',
      'bannerPath': 'asset/image/company/ibm malaysia company.webp',
      'allowance': 'RM1,200 - RM1,600',
      'reviews': [
        {'user': 'Marcus C.', 'rating': 4.7, 'comment': 'Excellent AI training and resources.', 'isSample': true},
        {'user': 'Jane D.', 'rating': 4.5, 'comment': 'A legacy of innovation you can feel.', 'isSample': true}
      ]
    },
    {
      'name': 'Intel Malaysia',
      'industry': 'Semiconductor Technology',
      'location': 'Penang',
      'positions': ['Chip Design Intern', 'Software Engineering Intern', 'Automation Intern', 'AI Research Intern', 'Manufacturing Technology Intern'],
      'description': 'Intel is an industry leader, creating world-changing technology that enables global progress and enriches lives. Inspired by Moore’s Law, we continuously work to advance the design and manufacturing of semiconductors to help address our customers’ greatest challenges. Intel Malaysia is one of Intel’s largest assembly and test sites.',
      'rating': '4.8',
      'imagePath': 'asset/image/Intel.png',
      'bannerPath': 'asset/image/company/intel company.jpg',
      'allowance': 'RM1,500 - RM2,000',
      'reviews': [
        {'user': 'Lee K.', 'rating': 4.9, 'comment': 'Penang hub is huge! Incredible hardware experience.', 'isSample': true},
        {'user': 'Anwar S.', 'rating': 4.7, 'comment': 'Very systematic approach to engineering.', 'isSample': true}
      ]
    },
    {
      'name': 'JobStreet by SEEK',
      'industry': 'Online Recruitment',
      'location': 'Kuala Lumpur',
      'positions': ['Software Engineering Intern', 'Data Analytics Intern', 'Digital Marketing Intern', 'Business Development Intern'],
      'description': 'JobStreet is a leading online job board presently covering the recruitment and management of employment in Malaysia, Philippines, Singapore, Indonesia, and Vietnam. As part of SEEK, JobStreet is dedicated to helping people find jobs they love and helping employers find the right talent to grow their businesses.',
      'rating': '4.5',
      'imagePath': 'asset/image/jobstreet-icon-filled-256.png',
      'bannerPath': 'asset/image/company/jobstreet by seek company.webp',
      'allowance': 'RM1,000 - RM1,400',
      'reviews': [
        {'user': 'Zara F.', 'rating': 4.4, 'comment': 'Great to see how the hiring platform works from the inside.', 'isSample': true},
        {'user': 'Ben T.', 'rating': 4.6, 'comment': 'Collaborative team and fun environment.', 'isSample': true}
      ]
    },
    {
      'name': 'KPMG Malaysia',
      'industry': 'Professional Services',
      'location': 'Petaling Jaya, Selangor',
      'positions': ['Auditing Intern', 'Consulting Intern', 'Taxation Intern', 'Risk Management Intern'],
      'description': 'KPMG is a global network of professional firms providing Audit, Tax and Advisory services. We operate in 147 countries and territories. KPMG Malaysia has been providing professional services for over 90 years, helping organizations to navigate complexity and achieve sustainable growth.',
      'rating': '4.5',
      'imagePath': 'asset/image/KPMG.png',
      'bannerPath': 'asset/image/company/kpmg malaysia company.jpg',
      'allowance': 'RM1,000 - RM1,200',
      'reviews': [
        {'user': 'Heng L.', 'rating': 4.5, 'comment': 'Excellent tax and advisory training.', 'isSample': true},
        {'user': 'Nur A.', 'rating': 4.3, 'comment': 'Very professional and well-structured.', 'isSample': true}
      ]
    },
    {
      'name': 'Maxis',
      'industry': 'Telecommunications',
      'location': 'Kuala Lumpur',
      'positions': ['Network Engineering Intern', 'Software Development Intern', 'Data Analytics Intern', 'Marketing Intern'],
      'description': 'Maxis is Malaysia’s leading integrated communications and digital services company, enabling individuals, families, and businesses to stay connected in an always-on world. We are committed to delivering the best network experience and innovative digital services, underpinned by our goal to be the preferred digital partner for the nation.',
      'rating': '4.5',
      'imagePath': 'asset/image/Maxis.png',
      'bannerPath': 'asset/image/company/maxis company.jpg',
      'allowance': 'RM1,000 - RM1,500',
      'reviews': [
        {'user': 'Syed M.', 'rating': 4.5, 'comment': 'The "Always On" culture is real. Very inspiring!', 'isSample': true},
        {'user': 'Joanne P.', 'rating': 4.4, 'comment': 'Great marketing insights.', 'isSample': true}
      ]
    },
    {
      'name': 'Microsoft Malaysia',
      'industry': 'Technology & Software',
      'location': 'Kuala Lumpur',
      'positions': ['Software Engineering Intern', 'Cloud Solution Architect Intern', 'Data & AI Intern', 'Cybersecurity Intern'],
      'description': 'Microsoft’s mission is to empower every person and every organization on the planet to achieve more. In Malaysia, Microsoft is a key driver of the digital economy, providing cloud services, software, and hardware that enable transformation across all sectors. It is a place where you can build the future of AI and cloud computing.',
      'rating': '4.8',
      'imagePath': 'asset/image/Windows.png',
      'bannerPath': 'asset/image/company/microsoft company.jpg',
      'allowance': 'RM1,500 - RM2,500',
      'reviews': [
        {'user': 'Tariq Z.', 'rating': 4.9, 'comment': 'Cloud and AI at its best. Great learning path.', 'isSample': true},
        {'user': 'Linda J.', 'rating': 4.7, 'comment': 'Diverse and inclusive culture.', 'isSample': true}
      ]
    },
    {
      'name': 'Maybank',
      'industry': 'Banking & Financial Services',
      'location': 'Kuala Lumpur',
      'positions': ['Finance Intern', 'Digital Banking Intern', 'Cybersecurity Intern', 'Analytics Intern', 'Customer Service Management Intern'],
      'description': 'Maybank is Malaysia’s largest financial services group and one of the leading banking groups in Southeast Asia. With a mission of "Humanising Financial Services," Maybank is committed to providing essential financial services to the community and driving economic growth across the region.',
      'rating': '4.5',
      'imagePath': 'asset/image/maybank.png',
      'bannerPath': 'asset/image/company/maybank company.webp',
      'allowance': 'RM1,000 - RM1,200',
      'reviews': [
        {'user': 'Azman R.', 'rating': 4.5, 'comment': 'Humanising banking is a great vision to work for.', 'isSample': true},
        {'user': 'Siew L.', 'rating': 4.4, 'comment': 'Solid banking foundation.', 'isSample': true}
      ]
    },
    {
      'name': 'Oracle Malaysia',
      'industry': 'Enterprise Software & Cloud Computing',
      'location': 'Kuala Lumpur',
      'positions': ['Cloud Services Intern', 'Software Engineering Intern', 'Database Administration Intern', 'Technical Consulting Intern'],
      'description': 'Oracle is a cloud technology company that provides organizations around the world with computing infrastructure and software to help them innovate, unlock efficiencies and become more effective. Oracle Malaysia supports the digital transformation of businesses through its world-leading database and cloud technologies.',
      'rating': '4.7',
      'imagePath': 'asset/image/Oracle.png',
      'bannerPath': 'asset/image/company/oracle malaysia company.jpg',
      'allowance': 'RM1,300 - RM1,900',
      'reviews': [
        {'user': 'Nitin S.', 'rating': 4.8, 'comment': 'Expertise in database tech is unmatched.', 'isSample': true},
        {'user': 'Kelly O.', 'rating': 4.6, 'comment': 'Great consulting experience.', 'isSample': true}
      ]
    },
    {
      'name': 'Petronas',
      'industry': 'Energy & Oil and Gas',
      'location': 'Kuala Lumpur',
      'positions': ['Engineering Intern', 'Geoscience Intern', 'Data Analytics Intern', 'Finance Intern', 'Project Management Intern'],
      'description': 'PETRONAS is a dynamic global energy group with a presence in over 50 countries. As Malaysia’s national oil and gas company, PETRONAS is committed to providing cleaner energy solutions and driving progress towards a sustainable future. We are a pioneer in energy innovation and a key player in the global energy transition.',
      'rating': '4.8',
      'imagePath': 'asset/image/petronas.png',
      'bannerPath': 'asset/image/company/petronas company.jpg',
      'allowance': 'RM1,000 - RM1,500',
      'reviews': [
        {'user': 'Ahmad F.', 'rating': 4.9, 'comment': 'Pride of the nation. Excellent technical training.', 'isSample': true},
        {'user': 'Mei L.', 'rating': 4.7, 'comment': 'Sustainability initiatives are very interesting.', 'isSample': true}
      ]
    },
    {
      'name': 'Public Bank',
      'industry': 'Banking & Financial Services',
      'location': 'Kuala Lumpur',
      'positions': ['Banking Operations Intern', 'Finance Intern', 'Compliance Intern', 'Customer Relationship Management Intern'],
      'description': 'Public Bank is one of the largest and most efficient banks in Malaysia, known for its strong financial performance and commitment to excellence. We offer a wide range of financial services and are dedicated to providing the best banking experience to our customers through innovation and integrity.',
      'rating': '4.4',
      'imagePath': 'asset/image/Public Bank.png',
      'bannerPath': 'asset/image/company/public bank company.webp',
      'allowance': 'RM800 - RM1,100',
      'reviews': [
        {'user': 'Yusof I.', 'rating': 4.3, 'comment': 'Disciplined and efficient working culture.', 'isSample': true},
        {'user': 'Chin S.', 'rating': 4.5, 'comment': 'Very stable and professional bank.', 'isSample': true}
      ]
    },
    {
      'name': 'PwC Malaysia',
      'industry': 'Professional Services',
      'location': 'Kuala Lumpur',
      'positions': ['Auditing Intern', 'Consulting Intern', 'Financial Analysis Intern', 'Technology Advisory Intern'],
      'description': 'At PwC, our purpose is to build trust in society and solve important problems. We’re a network of firms in 157 countries with more than 276,000 people who are committed to delivering quality in assurance, advisory and tax services. PwC Malaysia is a leading professional services firm, helping clients navigate the complexities of the digital age.',
      'rating': '4.6',
      'imagePath': 'asset/image/pwc.png',
      'bannerPath': 'asset/image/company/pwc malaysia company.jpg',
      'allowance': 'RM1,000 - RM1,200',
      'reviews': [
        {'user': 'Brenda K.', 'rating': 4.7, 'comment': 'Amazing people and great networking.', 'isSample': true},
        {'user': 'Vikram R.', 'rating': 4.5, 'comment': 'Challenging projects that make a difference.', 'isSample': true}
      ]
    },
    {
      'name': 'RHB Bank',
      'industry': 'Banking & Financial Services',
      'location': 'Kuala Lumpur',
      'positions': ['Banking Operations Intern', 'Finance Intern', 'Analytics Intern', 'Technology-driven Banking Intern'],
      'description': 'RHB Banking Group is one of the largest fully integrated financial services groups in Malaysia. With a focus on providing seamless financial solutions, RHB is committed to driving innovation in digital banking and providing exceptional service to its customers across the ASEAN region.',
      'rating': '4.4',
      'imagePath': 'asset/image/rhb.png',
      'bannerPath': 'asset/image/company/rhb bank company.webp',
      'allowance': 'RM800 - RM1,100',
      'reviews': [
        {'user': 'Danial H.', 'rating': 4.4, 'comment': 'Innovative digital banking projects.', 'isSample': true},
        {'user': 'Roslina A.', 'rating': 4.2, 'comment': 'Friendly work environment.', 'isSample': true}
      ]
    },
    {
      'name': 'Samsung Malaysia',
      'industry': 'Consumer Electronics & Technology',
      'location': 'Kuala Lumpur',
      'positions': ['Engineering Intern', 'Software Development Intern', 'Marketing Intern', 'Supply Chain Management Intern', 'Product Management Intern'],
      'description': 'Samsung is a global leader in technology, opening new possibilities for people everywhere. Through relentless innovation and discovery, we are transforming the worlds of TVs, smartphones, wearable devices, tablets, digital appliances, and more. Samsung Malaysia is a key part of this journey, bringing the latest tech to the regional market.',
      'rating': '4.7',
      'imagePath': 'asset/image/Samsung.png',
      'bannerPath': 'asset/image/company/samsung malaysia company.png',
      'allowance': 'RM1,200 - RM1,800',
      'reviews': [
        {'user': 'Boon S.', 'rating': 4.8, 'comment': 'Fast-paced and always ahead of the curve.', 'isSample': true},
        {'user': 'Indah W.', 'rating': 4.6, 'comment': 'Great marketing and product exposure.', 'isSample': true}
      ]
    },
    {
      'name': 'Shell',
      'industry': 'Energy',
      'location': 'Kuala Lumpur',
      'positions': ['Engineering Intern', 'Environmental Management Intern', 'Finance Intern', 'Digital Technologies Intern'],
      'description': 'Shell is a global group of energy and petrochemical companies, with a mission to power progress together with more and cleaner energy solutions. Shell Malaysia has been a part of the nation’s journey for over a century, contributing to the development of the energy sector and driving the transition to a sustainable energy future.',
      'rating': '4.6',
      'imagePath': 'asset/image/Shell.png',
      'bannerPath': 'asset/image/company/shell company.webp',
      'allowance': 'RM1,000 - RM1,500',
      'reviews': [
        {'user': 'Karim J.', 'rating': 4.7, 'comment': 'Safety-first culture is very impressive.', 'isSample': true},
        {'user': 'Laila O.', 'rating': 4.5, 'comment': 'Global opportunities and diverse teams.', 'isSample': true}
      ]
    },
    {
      'name': 'Shopee Malaysia',
      'industry': 'E-Commerce',
      'location': 'Kuala Lumpur',
      'positions': ['Software Engineering Intern', 'Business Intelligence Intern', 'Operations Intern', 'Marketing Intern', 'Product Development Intern'],
      'description': 'Shopee is the leading e-commerce platform in Southeast Asia and Taiwan. It is a platform tailored for the region, providing customers with an easy, secure, and fast online shopping experience through strong payment and logistical support. Shopee is part of Sea Limited, a leader in digital entertainment, e-commerce, and digital financial services.',
      'rating': '4.7',
      'imagePath': 'asset/image/shopee.png',
      'bannerPath': 'asset/image/company/shopee malaysia company.jpg',
      'allowance': 'RM1,200 - RM1,800',
      'reviews': [
        {'user': 'Ming H.', 'rating': 4.8, 'comment': 'Energetic environment. Never a dull moment.', 'isSample': true},
        {'user': 'Sasha B.', 'rating': 4.6, 'comment': 'Learned a lot about e-commerce operations.', 'isSample': true}
      ]
    },
    {
      'name': 'Siemens Malaysia',
      'industry': 'Industrial Technology',
      'location': 'Kuala Lumpur',
      'positions': ['Engineering Intern', 'Automation Intern', 'Software Development Intern', 'Project Management Intern'],
      'description': 'Siemens is a global technology powerhouse that has stood for engineering excellence, innovation, quality, reliability, and internationality for more than 170 years. Siemens Malaysia provides advanced solutions in the fields of electrification, automation, and digitalization, helping the nation build a more sustainable and efficient future.',
      'rating': '4.6',
      'imagePath': 'asset/image/Siemens.png',
      'bannerPath': 'asset/image/company/siemens malaysia company.jpg',
      'allowance': 'RM1,000 - RM1,500',
      'reviews': [
        {'user': 'Rudy V.', 'rating': 4.5, 'comment': 'Top-tier engineering solutions and automation.', 'isSample': true},
        {'user': 'Aishah K.', 'rating': 4.7, 'comment': 'Great for learning about smart infrastructure.', 'isSample': true}
      ]
    },
    {
      'name': 'TIME dotCom',
      'industry': 'Telecommunications & Internet Services',
      'location': 'Kuala Lumpur',
      'positions': ['Networking Intern', 'Cloud Computing Intern', 'Cybersecurity Intern', 'Business Operations Intern'],
      'description': 'TIME dotCom is a telecommunications provider that delivers high-speed fiber connectivity and innovative digital solutions to residents and businesses in Malaysia. We are committed to providing the best internet experience, underpinned by our goal to be the fastest and most reliable network in the country.',
      'rating': '4.5',
      'imagePath': 'asset/image/time.png',
      'bannerPath': 'asset/image/company/time dotcom company.jpeg',
      'allowance': 'RM1,000 - RM1,300',
      'reviews': [
        {'user': 'Gary L.', 'rating': 4.6, 'comment': 'Speed and reliability is in our DNA.', 'isSample': true},
        {'user': 'Hana P.', 'rating': 4.4, 'comment': 'Cool office and helpful team.', 'isSample': true}
      ]
    },
    {
      'name': 'Telekom Malaysia (TM)',
      'industry': 'Telecommunications',
      'location': 'Kuala Lumpur',
      'positions': ['Network Engineering Intern', 'Software Development Intern', 'Digital Transformation Intern', 'Customer Experience Intern'],
      'description': 'Telekom Malaysia is the nation’s leading integrated telecommunications provider, committed to connecting Malaysians and driving the nation’s digital transformation. TM offers a comprehensive range of communication services and solutions in fixed-line, mobile, data, and internet services, helping individuals and businesses stay connected and grow.',
      'rating': '4.5',
      'imagePath': 'asset/image/TM.png',
      'bannerPath': 'asset/image/company/telekom malaysia company.jpg',
      'allowance': 'RM800 - RM1,200',
      'reviews': [
        {'user': 'Zaki R.', 'rating': 4.3, 'comment': 'The backbone of Malaysia\'s connectivity.', 'isSample': true},
        {'user': 'Sherly T.', 'rating': 4.5, 'comment': 'Great digital transformation initiatives.', 'isSample': true}
      ]
    },
    {
      'name': 'Tesla',
      'industry': 'Electric Vehicles & Clean Energy',
      'location': 'Cyberjaya',
      'positions': ['Software Engineering Intern', 'Mechanical Engineering Intern', 'AI Intern', 'Data Analytics Intern', 'Manufacturing Technologies Intern'],
      'description': 'Tesla’s mission is to accelerate the world’s transition to sustainable energy. We design, manufacture, sell, and service the world’s best solar technology, energy storage systems, and electric vehicles, providing customers the opportunity to generate, store and consume energy entirely sustainably. Tesla Malaysia is part of this global mission to revolutionize transport and energy.',
      'rating': '4.9',
      'imagePath': 'asset/image/Tesla.png',
      'bannerPath': 'asset/image/company/tesla company.jpg',
      'allowance': 'RM1,500 - RM2,500',
      'reviews': [
        {'user': 'Elon M. (Fan)', 'rating': 5.0, 'comment': 'Working on the future of energy. Absolutely mind-blowing.', 'isSample': true},
        {'user': 'Sarah W.', 'rating': 4.8, 'comment': 'Intense work but you see the impact immediately.', 'isSample': true}
      ]
    },
    {
      'name': 'iPrice Group',
      'industry': 'E-Commerce & Digital Technology',
      'location': 'Kuala Lumpur',
      'positions': ['Software Engineering Intern', 'Digital Marketing Intern', 'Data Analytics Intern', 'Product Management Intern'],
      'description': 'iPrice Group is Southeast Asia’s leading online shopping companion. With a mission to bring a greater level of transparency, convenience, and trust to the e-commerce market, iPrice helps consumers compare prices and discover products across thousands of online stores. We leverage data and technology to make online shopping easier and more rewarding for everyone.',
      'rating': '4.4',
      'imagePath': 'asset/image/Iprice.png',
      'bannerPath': 'asset/image/company/iprice group company.jpg',
      'allowance': 'RM800 - RM1,200',
      'reviews': [
        {'user': 'Budi S.', 'rating': 4.5, 'comment': 'Great for learning affiliate marketing and data.', 'isSample': true},
        {'user': 'Laila K.', 'rating': 4.3, 'comment': 'Very multicultural and diverse team.', 'isSample': true}
      ]
    },
  ];

  Future<void> uploadCompanies() async {
    final collection = _firestore.collection('companies');
    
    debugPrint("[FIRESTORE] SYNC: Starting smart synchronization...");

    try {
      final snapshot = await collection.get();
      final Map<String, Map<String, dynamic>> remoteDocs = {
        for (var doc in snapshot.docs) doc.id: doc.data()
      };
      
      final batch = _firestore.batch();
      bool hasChanges = false;
      
      final Set<String> localNames = {};
      for (var localCompany in companiesData) {
        final String name = localCompany['name'];
        localNames.add(name);
        
        final remoteCompany = remoteDocs[name];
        
        // Update if document doesn't exist OR if local data (excluding reviews) has changed
        if (remoteCompany == null || !_isSame(localCompany, remoteCompany)) {
          debugPrint("[FIRESTORE] SYNC: Updating/Adding $name");
          final docRef = collection.doc(name);
          
          // PRESERVE REVIEWS: Merge remote reviews with sample ones
          final List<dynamic> mergedReviews = List.from(remoteCompany?['reviews'] ?? localCompany['reviews']);
          
          batch.set(docRef, {
            ...localCompany,
            'reviews': mergedReviews,
            'lastUpdated': FieldValue.serverTimestamp(),
          });
          hasChanges = true;
        }
      }
      
      for (var remoteId in remoteDocs.keys) {
        if (!localNames.contains(remoteId)) {
          debugPrint("[FIRESTORE] SYNC: Removing old entry $remoteId");
          batch.delete(collection.doc(remoteId));
          hasChanges = true;
        }
      }
      
      if (hasChanges) {
        await batch.commit();
        debugPrint("[FIRESTORE] SYNC: Successfully synced changes to Firestore.");
      } else {
        debugPrint("[FIRESTORE] SYNC: Data is already up to date. No writes performed.");
      }
    } catch (e) {
      debugPrint("[FIRESTORE] SYNC ERROR: $e");
    }
  }

  // Simplified comparison: Ignores reviews so user reviews don't trigger constant syncs/overwrites
  bool _isSame(Map<String, dynamic> local, Map<String, dynamic> remote) {
    try {
      if (local['name'] != remote['name']) return false;
      if (local['industry'] != remote['industry']) return false;
      if (local['location'] != remote['location']) return false;
      if (local['description'] != remote['description']) return false;
      if (local['rating'].toString() != remote['rating'].toString()) return false;
      if (local['imagePath'] != remote['imagePath']) return false;
      if (local['bannerPath'] != remote['bannerPath']) return false;
      if (local['allowance'] != remote['allowance']) return false;
      
      final localPos = local['positions'] as List;
      final remotePos = remote['positions'] as List;
      if (localPos.length != remotePos.length) return false;
      for (int i = 0; i < localPos.length; i++) {
        if (localPos[i] != remotePos[i]) return false;
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<List<Map<String, dynamic>>> getCompanies() {
    return _firestore.collection('companies').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }
}
