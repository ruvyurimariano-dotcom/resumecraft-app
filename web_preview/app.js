// ResumeCraft Mobile Simulator Engine

// Global State
const state = {
  activeResume: {
    id: 'res_sample_1',
    title: 'Alex Morgan - Software Engineer',
    resumeType: 'Professional Resume',
    personalInfo: {
      fullName: 'Alex Morgan',
      professionalTitle: 'Senior Full Stack Engineer',
      email: 'alex.morgan@example.com',
      phone: '+1 (555) 234-5678',
      location: 'San Francisco, CA',
      website: 'https://alexmorgan.dev',
      linkedIn: 'https://linkedin.com/in/alexmorgan',
      portfolio: 'https://github.com/alexmorgan',
      profilePhoto: ''
    },
    summary: 'Passionate and results-driven Software Engineer with 5+ years of experience crafting high-performance mobile and cloud architectures. Proven expertise in Flutter, Dart, TypeScript, and microservices with a strong record of optimizing app load times by 40% and leading agile cross-functional teams.',
    experiences: [
      {
        id: 'exp_1',
        jobTitle: 'Senior Mobile Engineer',
        company: 'TechFlow Systems',
        location: 'San Francisco, CA',
        startDate: '2021-03',
        endDate: '',
        isCurrentlyWorking: true,
        description: 'Spearheaded the redesign and mobile rewrite of the flagship fintech client application using clean architecture.',
        achievements: [
          'Architected state management reducing app memory footprint by 32% and crash rate to under 0.01%.',
          'Mentored 6 junior engineers and implemented automated CI/CD pipeline reducing build release cycle from 3 days to 45 minutes.'
        ]
      },
      {
        id: 'exp_2',
        jobTitle: 'Software Engineer',
        company: 'Apex Innovations',
        location: 'Austin, TX',
        startDate: '2019-01',
        endDate: '2021-02',
        isCurrentlyWorking: false,
        description: 'Developed customer-facing APIs and progressive web features serving 250,000+ daily active users.',
        achievements: [
          'Integrated real-time websocket synchronization resulting in a 45% increase in user session engagement.',
          'Collaborated with UX team to achieve 98% accessibility compliance score.'
        ]
      }
    ],
    educations: [
      {
        id: 'edu_1',
        degree: 'B.S. in Computer Science',
        institution: 'University of California, Berkeley',
        location: 'Berkeley, CA',
        startDate: '2015-08',
        graduationDate: '2019-05',
        gpa: '3.85',
        description: 'Dean’s Honors List, President of Mobile App Developers Club.'
      }
    ],
    skills: [
      { name: 'Flutter & Dart', level: 'Expert', pct: 1.0 },
      { name: 'TypeScript & Node.js', level: 'Advanced', pct: 0.8 },
      { name: 'REST & GraphQL APIs', level: 'Expert', pct: 1.0 },
      { name: 'CI/CD & Docker', level: 'Intermediate', pct: 0.6 },
      { name: 'Agile Leadership', level: 'Advanced', pct: 0.8 }
    ],
    projects: [
      {
        id: 'proj_1',
        projectName: 'Pulse Cloud Monitor',
        role: 'Lead Developer',
        description: 'Cross-platform telemetry app monitoring distributed server health metrics in real-time.',
        technologies: ['Flutter', 'Go', 'Prometheus'],
        projectUrl: 'https://github.com/alexmorgan/pulse-monitor'
      }
    ],
    certifications: [
      {
        id: 'cert_1',
        certificationName: 'AWS Certified Solutions Architect',
        issuingOrganization: 'Amazon Web Services',
        credentialId: 'AWS-PSA-920194',
        credentialUrl: 'https://credly.com/badges/sample'
      }
    ],
    languages: [
      { language: 'English', proficiency: 'Native' },
      { language: 'Spanish', proficiency: 'Intermediate' }
    ],
    references: [
      {
        id: 'ref_1',
        name: 'Sarah Jenkins',
        jobTitle: 'VP of Engineering',
        company: 'TechFlow Systems',
        email: 'sarah.jenkins@techflow.com',
        phone: '+1 (555) 890-1234'
      }
    ],
    includeReferences: true,
    customization: {
      templateId: 'modern_pro',
      colorHex: '#2563EB',
      fontFamily: 'Plus Jakarta Sans',
      layout: 'twoColumn', // 'oneColumn', 'twoColumn', 'compact', 'spacious'
      sectionVisibility: {
        Summary: true,
        Experience: true,
        Education: true,
        Skills: true,
        Projects: true,
        Certifications: true,
        Languages: true,
        References: true
      }
    }
  },
  savedResumes: [],
  user: {
    name: 'Alex Morgan',
    email: 'alex.morgan@example.com',
    isPro: false
  },
  builderStep: 0,
  zoomScale: 1.0,
  history: []
};

// Available Templates
const TEMPLATES = [
  { id: 'modern_pro', name: 'Modern Pro', category: 'Modern', color: '#2563EB', isPro: false, desc: 'Sleek two-column header with balanced typography and clean section accents.' },
  { id: 'clean_ats', name: 'Clean ATS Standard', category: 'ATS Friendly', color: '#1E3A8A', isPro: false, desc: 'Optimized for high parser pass rates, standard single-column semantic layout.' },
  { id: 'executive_suite', name: 'Executive Suite', category: 'Executive', color: '#18181B', isPro: true, desc: 'Sophisticated serif styling with dignified dark accents for leadership roles.' },
  { id: 'minimal_slate', name: 'Minimal Slate', category: 'Minimal', color: '#475569', isPro: false, desc: 'Understated elegance with subtle dividers and maximum reading clarity.' },
  { id: 'creative_edge', name: 'Creative Edge', category: 'Creative', color: '#059669', isPro: true, desc: 'Vibrant sidebar layout perfect for designers, tech leads, and innovators.' },
  { id: 'student_starter', name: 'Campus Starter', category: 'Student', color: '#2563EB', isPro: false, desc: 'Structured layout emphasizing education, internships, projects, and skills.' },
  { id: 'corporate_elite', name: 'Corporate Elite', category: 'Professional', color: '#991B1B', isPro: true, desc: 'Timeless professional hierarchy favored by Fortune 500 recruiters.' }
];

// Resume Types
const RESUME_TYPES = [
  { title: 'Professional Resume', desc: 'Best for experienced professionals with 2+ years of industry background.', icon: 'business_center' },
  { title: 'Student Resume', desc: 'Tailored for current students and interns focusing on coursework & campus roles.', icon: 'school' },
  { title: 'Entry-Level Resume', desc: 'Ideal for recent graduates showcasing practical projects, skills, and certifications.', icon: 'rocket_launch' },
  { title: 'Creative Resume', desc: 'Compelling visual layout for designers, creative directors, and content creators.', icon: 'palette' },
  { title: 'Academic CV', desc: 'Comprehensive curriculum vitae for scholars, researchers, and university faculty.', icon: 'menu_book' },
  { title: 'Executive Resume', desc: 'High-impact presentation for VPs, directors, and C-level executive leaders.', icon: 'military_tech' }
];

// Step names
const BUILDER_STEPS = ['Personal', 'Summary', 'Experience', 'Education', 'Skills', 'Projects', 'Certifications', 'Languages', 'References', 'Finish'];

// Initialize App
document.addEventListener('DOMContentLoaded', () => {
  // Populate saved resumes initially
  state.savedResumes = [JSON.parse(JSON.stringify(state.activeResume))];
  
  // Real-time clock update
  updateClock();
  setInterval(updateClock, 1000);

  // Setup Event Handlers
  setupNavigation();
  setupOnboarding();
  setupAuth();
  setupHomeDashboard();
  setupBuilder();
  setupPreview();
  setupAtsChecker();
  setupJobMatcher();
  setupAiAssistant();
  setupExport();
  setupProfileAndSettings();
  setupSimulatorControls();

  // Launch animated splash sequence
  playSplashScreen();
});

function updateClock() {
  const d = new Date();
  let hours = d.getHours();
  let minutes = d.getMinutes();
  hours = hours < 10 ? '0' + hours : hours;
  minutes = minutes < 10 ? '0' + minutes : minutes;
  const timeEl = document.getElementById('status-time');
  if (timeEl) timeEl.textContent = `${hours}:${minutes}`;
}

// Navigation Helper
function navigateTo(screenId, addToHistory = true) {
  const currentActive = document.querySelector('.app-screen.active');
  if (currentActive && addToHistory) {
    state.history.push(currentActive.id);
  }
  
  document.querySelectorAll('.app-screen').forEach(s => s.classList.remove('active'));
  const target = document.getElementById(screenId);
  if (target) {
    target.classList.add('active');
    target.scrollTop = 0;
  }
}

function goBack() {
  if (state.history.length > 0) {
    const prev = state.history.pop();
    navigateTo(prev, false);
  } else {
    showToast('At first screen');
  }
}

function showToast(msg) {
  const toast = document.getElementById('toast');
  toast.textContent = msg;
  toast.style.display = 'block';
  setTimeout(() => {
    toast.style.display = 'none';
  }, 2200);
}

// 1. Navigation Setup
function setupNavigation() {
  // Android back key
  document.getElementById('key-android-back').addEventListener('click', goBack);
  
  // Back buttons on top bars
  document.querySelectorAll('.btn-back').forEach(btn => {
    btn.addEventListener('click', goBack);
  });

  // Android home key
  document.getElementById('key-android-home').addEventListener('click', () => {
    state.history = [];
    navigateTo('screen-main-shell', false);
    switchTab(0);
  });

  // Material 3 Navigation Bar
  document.querySelectorAll('.nav-dest').forEach(btn => {
    btn.addEventListener('click', (e) => {
      const tabIdx = parseInt(btn.getAttribute('data-tab'));
      switchTab(tabIdx);
    });
  });
}

function switchTab(index) {
  document.querySelectorAll('.nav-dest').forEach(d => d.classList.remove('active'));
  document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('active'));
  
  const dest = document.querySelector(`.nav-dest[data-tab="${index}"]`);
  if (dest) dest.classList.add('active');

  const tabs = ['tab-home', 'tab-resumes', 'tab-templates', 'tab-tips', 'tab-profile'];
  const targetPane = document.getElementById(tabs[index]);
  if (targetPane) targetPane.classList.add('active');

  if (index === 1) renderResumesList();
  if (index === 2) renderTemplatesGrid();
  if (index === 3) renderTipsList();
}

// 2. Onboarding Setup
function setupOnboarding() {
  let currentSlide = 0;
  const slides = document.querySelectorAll('.carousel-slide');
  const dots = document.querySelectorAll('.dot');
  const nextBtn = document.getElementById('btn-next-onboarding');
  const guestBtn = document.getElementById('btn-guest-onboarding');

  function showSlide(idx) {
    slides.forEach(s => s.classList.remove('active'));
    dots.forEach(d => d.classList.remove('active'));
    slides[idx].classList.add('active');
    dots[idx].classList.add('active');

    if (idx === slides.length - 1) {
      nextBtn.innerHTML = 'Get Started <span class="material-symbols-rounded">arrow_forward</span>';
      guestBtn.classList.remove('hidden');
    } else {
      nextBtn.innerHTML = 'Next <span class="material-symbols-rounded">arrow_forward</span>';
      guestBtn.classList.add('hidden');
    }
  }

  nextBtn.addEventListener('click', () => {
    if (currentSlide < slides.length - 1) {
      currentSlide++;
      showSlide(currentSlide);
    } else {
      navigateTo('screen-login');
    }
  });

  document.getElementById('btn-skip-onboarding').addEventListener('click', () => {
    navigateTo('screen-main-shell');
    switchTab(0);
  });

  guestBtn.addEventListener('click', () => {
    state.user.name = 'Guest User';
    state.user.email = 'guest@resumecraft.local';
    document.querySelectorAll('.user-display-name').forEach(el => el.textContent = state.user.name);
    navigateTo('screen-main-shell');
    switchTab(0);
  });
}

// 3. Auth Setup
function setupAuth() {
  document.getElementById('btn-submit-login').addEventListener('click', () => {
    const email = document.getElementById('login-email').value.trim();
    if (email) {
      const name = email.split('@')[0];
      state.user.name = name.charAt(0).toUpperCase() + name.slice(1);
      state.user.email = email;
      document.querySelectorAll('.user-display-name').forEach(el => el.textContent = state.user.name);
      document.getElementById('user-display-email').textContent = email;
    }
    showToast('Logged in successfully!');
    navigateTo('screen-main-shell');
    switchTab(0);
  });

  document.getElementById('btn-login-guest').addEventListener('click', () => {
    navigateTo('screen-main-shell');
    switchTab(0);
  });

  document.getElementById('btn-goto-signup').addEventListener('click', () => {
    navigateTo('screen-signup');
  });

  document.getElementById('btn-signup-goto-login').addEventListener('click', () => {
    navigateTo('screen-login');
  });

  document.getElementById('btn-submit-signup').addEventListener('click', () => {
    const name = document.getElementById('signup-name').value.trim();
    const email = document.getElementById('signup-email').value.trim();
    if (name) state.user.name = name;
    if (email) state.user.email = email;
    document.querySelectorAll('.user-display-name').forEach(el => el.textContent = state.user.name);
    showToast('Account created!');
    navigateTo('screen-main-shell');
    switchTab(0);
  });

  // Forgot password
  document.getElementById('btn-goto-forgot').addEventListener('click', () => {
    navigateTo('screen-forgot-password');
  });
  document.getElementById('btn-send-otp').addEventListener('click', () => {
    document.getElementById('forgot-step-0').classList.add('hidden');
    document.getElementById('forgot-step-1').classList.remove('hidden');
  });
  document.getElementById('btn-verify-otp').addEventListener('click', () => {
    document.getElementById('forgot-step-1').classList.add('hidden');
    document.getElementById('forgot-step-2').classList.remove('hidden');
  });
  document.getElementById('btn-update-pwd').addEventListener('click', () => {
    document.getElementById('forgot-step-2').classList.add('hidden');
    document.getElementById('forgot-step-3').classList.remove('hidden');
  });
  document.getElementById('btn-finish-forgot').addEventListener('click', () => {
    navigateTo('screen-login');
  });
}

// 4. Home Dashboard Setup
function setupHomeDashboard() {
  document.getElementById('btn-create-resume').addEventListener('click', () => {
    renderResumeTypes();
    navigateTo('screen-resume-type');
  });

  document.getElementById('btn-home-edit-resume').addEventListener('click', () => {
    openResumeBuilder(state.activeResume);
  });

  document.getElementById('btn-home-preview-resume').addEventListener('click', () => {
    renderCanvas();
    navigateTo('screen-preview');
  });

  document.getElementById('card-ats-banner').addEventListener('click', () => {
    renderAtsChecker();
    navigateTo('screen-ats');
  });

  document.getElementById('link-view-all-resumes').addEventListener('click', () => {
    switchTab(1);
  });

  renderHomeMiniResumes();
}

function renderHomeMiniResumes() {
  const container = document.getElementById('home-resumes-list');
  container.innerHTML = '';
  state.savedResumes.forEach((r, idx) => {
    const card = document.createElement('div');
    card.className = 'resume-row-card';
    card.innerHTML = `
      <span class="material-symbols-rounded text-primary">description</span>
      <div style="flex:1">
        <h5>${r.title}</h5>
        <span class="sub">${r.resumeType} • 85% complete</span>
      </div>
      <span class="material-symbols-rounded chevron">chevron_right</span>
    `;
    card.addEventListener('click', () => {
      state.activeResume = r;
      renderCanvas();
      navigateTo('screen-preview');
    });
    container.appendChild(card);
  });
}

// 5. Create Resume Flow (Steps 1 & 2)
function renderResumeTypes() {
  const container = document.getElementById('resume-types-container');
  container.innerHTML = '';
  
  const STARTER_MODES = [
    {
      id: 'ai_smart',
      title: '⚡ AI Smart-Start by Role',
      desc: 'Auto-populates recruiter-tested achievements, keywords, and summary based on your target role.',
      icon: 'auto_awesome',
      recommended: true
    },
    {
      id: 'sample_draft',
      title: '📄 Executive Sample Draft',
      desc: 'Start with a comprehensive pre-filled resume and edit your details in real-time.',
      icon: 'description',
      recommended: false
    },
    {
      id: 'blank_canvas',
      title: '✏️ Start from Blank Canvas',
      desc: 'Build step-by-step from scratch with total creative freedom.',
      icon: 'edit_note',
      recommended: false
    }
  ];

  let selectedMode = 'ai_smart';

  STARTER_MODES.forEach(m => {
    const card = document.createElement('div');
    card.className = `card mb-2 ${selectedMode === m.id ? 'active-border' : ''}`;
    card.style.cursor = 'pointer';
    card.innerHTML = `
      <div class="d-flex align-center">
        <span class="material-symbols-rounded text-primary" style="font-size:24px">${m.icon}</span>
        <div class="ml-2" style="flex:1">
          <div class="d-flex align-center justify-between">
            <strong>${m.title}</strong>
            ${m.recommended ? '<span class="badge-pill bg-green-tint ml-1">POPULAR</span>' : ''}
          </div>
        </div>
      </div>
    `;
    card.addEventListener('click', () => {
      selectedMode = m.id;
      document.querySelectorAll('#resume-types-container .card').forEach(c => c.classList.remove('active-border'));
      card.classList.add('active-border');
    });
    container.appendChild(card);
  });

  // Role Quick Starters
  document.querySelectorAll('#role-quick-starters .chip').forEach(chip => {
    chip.onclick = () => {
      const role = chip.getAttribute('data-role');
      applyRolePreset(role);
      showToast(`Loaded ${role} starter profile!`);
      renderPickerTemplates();
      navigateTo('screen-template-picker');
    };
  });

  document.getElementById('btn-continue-to-templates').onclick = () => {
    if (selectedMode === 'blank_canvas') {
      state.activeResume.summary = '';
      state.activeResume.experiences = [];
      state.activeResume.skills = [];
      state.activeResume.projects = [];
    }
    renderPickerTemplates();
    navigateTo('screen-template-picker');
  };
}

function applyRolePreset(role) {
  state.activeResume.title = `${state.user.name} - ${role}`;
  state.activeResume.personalInfo.professionalTitle = role;

  if (role === 'Software Engineer') {
    state.activeResume.summary = 'Passionate Senior Software Engineer with 5+ years of experience architecting resilient mobile and cloud platforms. Proven track record of boosting app performance by 40% and leading cross-functional teams.';
    state.activeResume.skills = [
      { name: 'Flutter & Dart', level: 'Expert', pct: 1.0 },
      { name: 'TypeScript & Node.js', level: 'Expert', pct: 0.9 },
      { name: 'REST & GraphQL APIs', level: 'Expert', pct: 1.0 },
      { name: 'CI/CD & Docker', level: 'Advanced', pct: 0.8 },
      { name: 'Agile Leadership', level: 'Advanced', pct: 0.85 }
    ];
  } else if (role === 'Product Manager') {
    state.activeResume.summary = 'Data-driven Product Manager with 4+ years spearheading mobile product discovery, roadmaps, and GTM strategy. Scaled MAU from 50k to 500k through customer interviews, user journey mapping, and A/B experimentation.';
    state.activeResume.skills = [
      { name: 'Product Roadmapping', level: 'Expert', pct: 1.0 },
      { name: 'A/B Testing & Mixpanel', level: 'Advanced', pct: 0.9 },
      { name: 'User Research & Journey Mapping', level: 'Expert', pct: 1.0 },
      { name: 'Agile & Scrum Sprints', level: 'Expert', pct: 0.95 },
      { name: 'Stakeholder Alignment', level: 'Advanced', pct: 0.85 }
    ];
  } else if (role === 'Data Analyst') {
    state.activeResume.summary = 'Quantitative Data Analyst adept at translating complex data sets into actionable business insights and real-time executive dashboards. Expert in SQL, Python, Tableau, and revenue modeling.';
    state.activeResume.skills = [
      { name: 'SQL & Database Optimization', level: 'Expert', pct: 1.0 },
      { name: 'Python (Pandas, NumPy)', level: 'Advanced', pct: 0.9 },
      { name: 'Tableau & PowerBI', level: 'Expert', pct: 0.95 },
      { name: 'Predictive Modeling', level: 'Intermediate', pct: 0.75 },
      { name: 'Executive Storytelling', level: 'Advanced', pct: 0.85 }
    ];
  } else if (role === 'Marketing Specialist') {
    state.activeResume.summary = 'Results-focused Growth Marketer with extensive experience scaling multi-channel digital campaigns. Increased conversion rates by 34% and decreased CAC by 28% across paid search, social, and email marketing.';
    state.activeResume.skills = [
      { name: 'Growth Marketing & SEO', level: 'Expert', pct: 1.0 },
      { name: 'Google Ads & Meta Ads', level: 'Advanced', pct: 0.9 },
      { name: 'Email Automation (HubSpot)', level: 'Expert', pct: 0.95 },
      { name: 'Content Strategy', level: 'Advanced', pct: 0.8 },
      { name: 'Data & ROI Attribution', level: 'Advanced', pct: 0.85 }
    ];
  } else {
    // Student / Graduate
    state.activeResume.summary = 'High-achieving graduate with strong academic foundation, leadership experience in campus organizations, and hands-on project work. Eager to apply analytical problem solving and fresh perspectives in an entry-level role.';
    state.activeResume.skills = [
      { name: 'Problem Solving & Critical Thinking', level: 'Advanced', pct: 0.9 },
      { name: 'Team Collaboration & Communication', level: 'Expert', pct: 1.0 },
      { name: 'Project Coordination', level: 'Advanced', pct: 0.85 },
      { name: 'Research & Data Analysis', level: 'Intermediate', pct: 0.8 }
    ];
  }
}

function renderPickerTemplates() {
  const container = document.getElementById('picker-templates-container');
  container.innerHTML = '';

  TEMPLATES.forEach(t => {
    const card = document.createElement('div');
    card.className = `template-card ${state.activeResume.customization.templateId === t.id ? 'active' : ''}`;
    card.innerHTML = `
      <div class="template-thumb" style="border-top: 3px solid ${t.color}">
        <div style="display:flex; justify-content:space-between">
          <div style="width:16px; height:16px; border-radius:50%; background:${t.color}"></div>
          ${t.isPro ? '<span class="badge-pro">PRO</span>' : ''}
        </div>
        <div style="width:50px; height:6px; background:${t.color}; border-radius:2px; margin-top:6px"></div>
        <div style="width:30px; height:4px; background:#94A3B8; border-radius:2px"></div>
      </div>
      <h4>${t.name}</h4>
      <span class="cat">${t.category}</span>
    `;
    card.addEventListener('click', () => {
      state.activeResume.customization.templateId = t.id;
      state.activeResume.customization.colorHex = t.color;
      document.querySelectorAll('#picker-templates-container .template-card').forEach(c => c.classList.remove('active'));
      card.classList.add('active');
    });
    container.appendChild(card);
  });

  document.getElementById('btn-start-building').onclick = () => {
    openResumeBuilder(state.activeResume);
  };
}

// 6. Resume Builder (10 Steps)
function openResumeBuilder(resume) {
  state.activeResume = resume;
  state.builderStep = 0;
  document.getElementById('builder-resume-title').textContent = resume.title;
  renderBuilderPills();
  renderBuilderCurrentStep();
  navigateTo('screen-builder');
}

function renderBuilderPills() {
  const container = document.getElementById('builder-step-pills');
  container.innerHTML = '';
  BUILDER_STEPS.forEach((name, idx) => {
    const pill = document.createElement('div');
    pill.className = `step-pill ${state.builderStep === idx ? 'active' : ''}`;
    pill.textContent = `${idx + 1}. ${name}`;
    pill.addEventListener('click', () => {
      state.builderStep = idx;
      renderBuilderPills();
      renderBuilderCurrentStep();
    });
    container.appendChild(pill);
  });
}

function renderBuilderCurrentStep() {
  document.getElementById('builder-step-num').textContent = `Step ${state.builderStep + 1} of 10`;
  document.getElementById('builder-step-name').textContent = BUILDER_STEPS[state.builderStep];
  
  const viewport = document.getElementById('builder-step-viewport');
  const r = state.activeResume;

  switch(state.builderStep) {
    case 0: // Personal
      viewport.innerHTML = `
        <div class="card p-3">
          <div class="text-center mb-3">
            <div class="avatar-circle" style="width:72px; height:72px; margin:0 auto">
              <span class="material-symbols-rounded" style="font-size:36px">person</span>
            </div>
            <button class="text-btn primary-text mt-1">Change Photo</button>
          </div>
          <div class="input-group">
            <label>Full Name *</label>
            <div class="input-field"><input type="text" id="inp-fullname" value="${r.personalInfo.fullName}"></div>
          </div>
          <div class="input-group">
            <label>Professional Title *</label>
            <div class="input-field"><input type="text" id="inp-title" value="${r.personalInfo.professionalTitle}"></div>
          </div>
          <div class="input-group">
            <label>Email Address *</label>
            <div class="input-field"><input type="email" id="inp-email" value="${r.personalInfo.email}"></div>
          </div>
          <div class="input-group">
            <label>Phone Number</label>
            <div class="input-field"><input type="text" id="inp-phone" value="${r.personalInfo.phone}"></div>
          </div>
          <div class="input-group">
            <label>Location / City, Country</label>
            <div class="input-field"><input type="text" id="inp-location" value="${r.personalInfo.location}"></div>
          </div>
          <div class="input-group">
            <label>LinkedIn Profile</label>
            <div class="input-field"><input type="text" id="inp-linkedin" value="${r.personalInfo.linkedIn}"></div>
          </div>
        </div>
      `;
      // Listeners
      ['fullname', 'title', 'email', 'phone', 'location', 'linkedin'].forEach(field => {
        const input = document.getElementById(`inp-${field}`);
        if (input) {
          input.addEventListener('input', (e) => {
            if (field === 'fullname') r.personalInfo.fullName = e.target.value;
            if (field === 'title') r.personalInfo.professionalTitle = e.target.value;
            if (field === 'email') r.personalInfo.email = e.target.value;
            if (field === 'phone') r.personalInfo.phone = e.target.value;
            if (field === 'location') r.personalInfo.location = e.target.value;
            if (field === 'linkedin') r.personalInfo.linkedIn = e.target.value;
            triggerAutosave();
          });
        }
      });
      break;

    case 1: // Summary
      viewport.innerHTML = `
        <div class="card banner-blue mb-2">
          <div class="d-flex align-center justify-between">
            <strong>AI Summary Assistant</strong>
            <button class="chip" id="btn-quick-ai-gen"><span class="material-symbols-rounded">auto_awesome</span> Generate with AI</button>
          </div>
        </div>
        <div class="card p-3">
          <label><strong>Professional Summary</strong></label>
          <textarea id="inp-summary" rows="7" class="mt-1" placeholder="Write a concise overview of your background, core strengths, and career trajectory...">${r.summary}</textarea>
        </div>
        <h4 class="mt-2">✨ Quick Summary Templates (Tap to Insert)</h4>
        <div class="suggestion-card" id="sug-sum-tech">
          <span class="material-symbols-rounded text-primary" style="font-size:18px">add_circle</span>
          <div><strong>Technical Impact:</strong> "Results-driven engineer specializing in scalable architectures and automated pipelines with 40% performance gains."</div>
        </div>
        <div class="suggestion-card" id="sug-sum-lead">
          <span class="material-symbols-rounded text-primary" style="font-size:18px">add_circle</span>
          <div><strong>Leadership Focus:</strong> "Strategic team lead with proven track record directing agile cross-functional sprints and mentoring junior talent."</div>
        </div>
      `;
      document.getElementById('inp-summary').addEventListener('input', (e) => {
        r.summary = e.target.value;
        triggerAutosave();
      });
      document.getElementById('btn-quick-ai-gen').onclick = () => {
        r.summary = `Accomplished and growth-focused ${r.personalInfo.professionalTitle} with 5+ years of success delivering scalable systems. Recognized for combining analytical rigor with strong cross-functional collaboration to optimize workflows, elevate product quality, and drive strategic goals.`;
        document.getElementById('inp-summary').value = r.summary;
        triggerAutosave();
        showToast('Generated summary with AI!');
      };
      document.getElementById('sug-sum-tech').onclick = () => {
        r.summary = `Results-driven ${r.personalInfo.professionalTitle} specializing in high-performance software design, cloud scalability, and CI/CD pipelines. Demonstrated track record of optimizing application response times by 40% while ensuring 99.9% uptime.`;
        document.getElementById('inp-summary').value = r.summary;
        triggerAutosave();
        showToast('Inserted technical summary!');
      };
      document.getElementById('sug-sum-lead').onclick = () => {
        r.summary = `Strategic and collaborative ${r.personalInfo.professionalTitle} with 5+ years leading cross-functional product teams. Champions engineering excellence, data-driven sprint planning, and mentorship to accelerate product delivery.`;
        document.getElementById('inp-summary').value = r.summary;
        triggerAutosave();
        showToast('Inserted leadership summary!');
      };
      break;

    case 2: // Experience
      let expHtml = `<div class="d-flex justify-between align-center mb-2"><h4>Work Experience (${r.experiences.length})</h4><button class="btn btn-sm btn-primary" id="btn-add-exp">+ Add Role</button></div>`;
      r.experiences.forEach((exp, idx) => {
        expHtml += `
          <div class="card mb-2 p-3">
            <div class="d-flex justify-between align-center">
              <strong>${exp.jobTitle || 'Untitled Role'}</strong>
              <button class="text-btn text-danger btn-remove-exp" data-idx="${idx}"><span class="material-symbols-rounded">delete</span></button>
            </div>
            <p class="text-muted" style="font-size:12px">${exp.company} • ${exp.startDate} - ${exp.isCurrentlyWorking ? 'Present' : exp.endDate}</p>
            <p class="mt-1" style="font-size:12.5px">${exp.description}</p>
          </div>
        `;
      });
      expHtml += `
        <h4 class="mt-3">✨ Recruiter-Tested Bullet Suggestions (Tap to Append)</h4>
        <div class="suggestion-card" id="sug-exp-perf">
          <span class="material-symbols-rounded text-green" style="font-size:18px">add_circle</span>
          <div>"Spearheaded performance optimization reducing server latency by 38% across 500k active users."</div>
        </div>
        <div class="suggestion-card" id="sug-exp-cicd">
          <span class="material-symbols-rounded text-green" style="font-size:18px">add_circle</span>
          <div>"Architected automated CI/CD deployment pipeline cutting release time from 3 days to 45 minutes."</div>
        </div>
        <div class="suggestion-card" id="sug-exp-team">
          <span class="material-symbols-rounded text-green" style="font-size:18px">add_circle</span>
          <div>"Mentored 6 engineers and implemented unit testing coverage achieving 94% test reliability."</div>
        </div>
      `;
      viewport.innerHTML = expHtml;
      
      document.getElementById('sug-exp-perf').onclick = () => {
        if (r.experiences.length > 0) {
          r.experiences[0].description += ' Spearheaded performance optimization reducing server latency by 38% across 500k active users.';
          triggerAutosave();
          renderBuilderCurrentStep();
          showToast('Appended achievement bullet!');
        }
      };
      document.getElementById('sug-exp-cicd').onclick = () => {
        if (r.experiences.length > 0) {
          r.experiences[0].description += ' Architected automated CI/CD deployment pipeline cutting release time from 3 days to 45 minutes.';
          triggerAutosave();
          renderBuilderCurrentStep();
          showToast('Appended pipeline bullet!');
        }
      };
      document.getElementById('sug-exp-team').onclick = () => {
        if (r.experiences.length > 0) {
          r.experiences[0].description += ' Mentored 6 engineers and implemented unit testing coverage achieving 94% test reliability.';
          triggerAutosave();
          renderBuilderCurrentStep();
          showToast('Appended leadership bullet!');
        }
      };

      document.getElementById('btn-add-exp').onclick = () => {
        r.experiences.push({
          id: 'exp_' + Date.now(),
          jobTitle: 'Software Engineer',
          company: 'Acme Global',
          startDate: '2022-01',
          endDate: '2023-12',
          isCurrentlyWorking: false,
          description: 'Designed core features and microservices.',
          achievements: ['Increased user retention by 20%.']
        });
        triggerAutosave();
        renderBuilderCurrentStep();
      };
      document.querySelectorAll('.btn-remove-exp').forEach(btn => {
        btn.onclick = () => {
          const idx = parseInt(btn.getAttribute('data-idx'));
          r.experiences.splice(idx, 1);
          triggerAutosave();
          renderBuilderCurrentStep();
        };
      });
      break;

    case 3: // Education
      let eduHtml = `<div class="d-flex justify-between align-center mb-2"><h4>Education (${r.educations.length})</h4><button class="btn btn-sm btn-primary" id="btn-add-edu">+ Add Degree</button></div>`;
      r.educations.forEach((edu, idx) => {
        eduHtml += `
          <div class="card mb-2 p-3">
            <div class="d-flex justify-between align-center">
              <strong>${edu.degree}</strong>
              <button class="text-btn text-danger btn-remove-edu" data-idx="${idx}"><span class="material-symbols-rounded">delete</span></button>
            </div>
            <p class="text-muted" style="font-size:12px">${edu.institution} • GPA: ${edu.gpa}</p>
          </div>
        `;
      });
      viewport.innerHTML = eduHtml;
      document.getElementById('btn-add-edu').onclick = () => {
        r.educations.push({
          id: 'edu_' + Date.now(),
          degree: 'M.S. in Software Systems',
          institution: 'Stanford University',
          gpa: '3.9'
        });
        triggerAutosave();
        renderBuilderCurrentStep();
      };
      document.querySelectorAll('.btn-remove-edu').forEach(btn => {
        btn.onclick = () => {
          const idx = parseInt(btn.getAttribute('data-idx'));
          r.educations.splice(idx, 1);
          triggerAutosave();
          renderBuilderCurrentStep();
        };
      });
      break;

    case 4: // Skills
      let skillsHtml = `
        <div class="card p-3 mb-2">
          <label><strong>Add New Skill</strong></label>
          <div class="d-flex mt-1">
            <input type="text" id="inp-new-skill" placeholder="e.g. Kotlin, Docker, React Native..." style="flex:1">
            <button class="btn btn-primary ml-1" id="btn-add-skill-val">Add</button>
          </div>
        </div>
        <h4>Added Skills (${r.skills.length})</h4>
        <div class="chips-wrap mt-2">
      `;
      r.skills.forEach((s, idx) => {
        skillsHtml += `
          <div class="chip" style="display:inline-flex; align-items:center; gap:6px">
            <span>${s.name} (${s.level})</span>
            <span class="material-symbols-rounded btn-remove-skill" data-idx="${idx}" style="font-size:14px; cursor:pointer">close</span>
          </div>
        `;
      });
      skillsHtml += `</div>`;
      viewport.innerHTML = skillsHtml;

      document.getElementById('btn-add-skill-val').onclick = () => {
        const val = document.getElementById('inp-new-skill').value.trim();
        if (val) {
          r.skills.push({ name: val, level: 'Advanced', pct: 0.8 });
          triggerAutosave();
          renderBuilderCurrentStep();
        }
      };
      document.querySelectorAll('.btn-remove-skill').forEach(btn => {
        btn.onclick = () => {
          const idx = parseInt(btn.getAttribute('data-idx'));
          r.skills.splice(idx, 1);
          triggerAutosave();
          renderBuilderCurrentStep();
        };
      });
      break;

    case 5: // Projects
      let projHtml = `<div class="d-flex justify-between align-center mb-2"><h4>Projects (${(r.projects || []).length})</h4><button class="btn btn-sm btn-primary" id="btn-add-proj">+ Add Project</button></div>`;
      (r.projects || []).forEach((proj, idx) => {
        projHtml += `
          <div class="card mb-2 p-3">
            <div class="d-flex justify-between align-center">
              <strong>${proj.projectName || 'Untitled Project'}</strong>
              <button class="text-btn text-danger btn-remove-proj" data-idx="${idx}"><span class="material-symbols-rounded">delete</span></button>
            </div>
            <p class="text-muted" style="font-size:12px">${proj.role || 'Developer'} • ${proj.technologies ? proj.technologies.join(', ') : ''}</p>
            <p class="mt-1" style="font-size:12.5px">${proj.description}</p>
          </div>
        `;
      });
      viewport.innerHTML = projHtml;
      document.getElementById('btn-add-proj').onclick = () => {
        if (!r.projects) r.projects = [];
        r.projects.push({
          id: 'proj_' + Date.now(),
          projectName: 'Smart Telemetry Dashboard',
          role: 'Lead Architect',
          description: 'Engineered real-time monitoring suite processing 10M+ events daily with zero downtime.',
          technologies: ['Flutter', 'Node.js', 'Redis']
        });
        triggerAutosave();
        renderBuilderCurrentStep();
      };
      document.querySelectorAll('.btn-remove-proj').forEach(btn => {
        btn.onclick = () => {
          const idx = parseInt(btn.getAttribute('data-idx'));
          r.projects.splice(idx, 1);
          triggerAutosave();
          renderBuilderCurrentStep();
        };
      });
      break;

    case 6: // Certifications
      let certHtml = `<div class="d-flex justify-between align-center mb-2"><h4>Certifications (${(r.certifications || []).length})</h4><button class="btn btn-sm btn-primary" id="btn-add-cert">+ Add Cert</button></div>`;
      (r.certifications || []).forEach((cert, idx) => {
        certHtml += `
          <div class="card mb-2 p-3">
            <div class="d-flex justify-between align-center">
              <strong>${cert.certificationName || 'Certification'}</strong>
              <button class="text-btn text-danger btn-remove-cert" data-idx="${idx}"><span class="material-symbols-rounded">delete</span></button>
            </div>
            <p class="text-muted" style="font-size:12px">${cert.issuingOrganization} • ID: ${cert.credentialId}</p>
          </div>
        `;
      });
      viewport.innerHTML = certHtml;
      document.getElementById('btn-add-cert').onclick = () => {
        if (!r.certifications) r.certifications = [];
        r.certifications.push({
          id: 'cert_' + Date.now(),
          certificationName: 'Google Associate Cloud Engineer',
          issuingOrganization: 'Google Cloud',
          credentialId: 'GCP-' + Math.floor(100000 + Math.random() * 900000)
        });
        triggerAutosave();
        renderBuilderCurrentStep();
      };
      document.querySelectorAll('.btn-remove-cert').forEach(btn => {
        btn.onclick = () => {
          const idx = parseInt(btn.getAttribute('data-idx'));
          r.certifications.splice(idx, 1);
          triggerAutosave();
          renderBuilderCurrentStep();
        };
      });
      break;

    case 7: // Languages
      let langHtml = `<div class="d-flex justify-between align-center mb-2"><h4>Languages (${(r.languages || []).length})</h4><button class="btn btn-sm btn-primary" id="btn-add-lang">+ Add Language</button></div>`;
      (r.languages || []).forEach((lang, idx) => {
        langHtml += `
          <div class="card mb-2 p-3">
            <div class="d-flex justify-between align-center">
              <strong>${lang.language}</strong>
              <button class="text-btn text-danger btn-remove-lang" data-idx="${idx}"><span class="material-symbols-rounded">delete</span></button>
            </div>
            <p class="text-muted" style="font-size:12px">Proficiency: ${lang.proficiency}</p>
          </div>
        `;
      });
      viewport.innerHTML = langHtml;
      document.getElementById('btn-add-lang').onclick = () => {
        if (!r.languages) r.languages = [];
        r.languages.push({
          language: 'German',
          proficiency: 'Professional Working'
        });
        triggerAutosave();
        renderBuilderCurrentStep();
      };
      document.querySelectorAll('.btn-remove-lang').forEach(btn => {
        btn.onclick = () => {
          const idx = parseInt(btn.getAttribute('data-idx'));
          r.languages.splice(idx, 1);
          triggerAutosave();
          renderBuilderCurrentStep();
        };
      });
      break;

    case 8: // References
      let refHtml = `<div class="d-flex justify-between align-center mb-2"><h4>References (${(r.references || []).length})</h4><button class="btn btn-sm btn-primary" id="btn-add-ref">+ Add Reference</button></div>`;
      (r.references || []).forEach((ref, idx) => {
        refHtml += `
          <div class="card mb-2 p-3">
            <div class="d-flex justify-between align-center">
              <strong>${ref.name}</strong>
              <button class="text-btn text-danger btn-remove-ref" data-idx="${idx}"><span class="material-symbols-rounded">delete</span></button>
            </div>
            <p class="text-muted" style="font-size:12px">${ref.jobTitle} • ${ref.company}</p>
            <p class="mt-1" style="font-size:12px; color:var(--primary)">${ref.email} | ${ref.phone}</p>
          </div>
        `;
      });
      viewport.innerHTML = refHtml;
      document.getElementById('btn-add-ref').onclick = () => {
        if (!r.references) r.references = [];
        r.references.push({
          id: 'ref_' + Date.now(),
          name: 'David Chen',
          jobTitle: 'Director of Product',
          company: 'Apex Innovations',
          email: 'david.chen@apex.com',
          phone: '+1 (555) 345-6789'
        });
        triggerAutosave();
        renderBuilderCurrentStep();
      };
      document.querySelectorAll('.btn-remove-ref').forEach(btn => {
        btn.onclick = () => {
          const idx = parseInt(btn.getAttribute('data-idx'));
          r.references.splice(idx, 1);
          triggerAutosave();
          renderBuilderCurrentStep();
        };
      });
      break;

    case 9: // Finish & Checklist
      viewport.innerHTML = `
        <div class="card p-3 text-center mb-3 banner-blue">
          <div class="avatar-circle" style="width:72px; height:72px; margin:0 auto; background:white; color:var(--primary); font-size:24px; font-weight:900">95%</div>
          <h3 class="mt-2">Ready for Applications</h3>
        </div>
        <h4>Section Checklist</h4>
        <div class="card mt-1">
          <div class="menu-item"><span class="material-symbols-rounded text-green">check_circle</span><span>Personal Information</span></div>
          <div class="menu-item"><span class="material-symbols-rounded text-green">check_circle</span><span>Professional Summary</span></div>
          <div class="menu-item"><span class="material-symbols-rounded text-green">check_circle</span><span>Work Experience (${r.experiences.length} roles)</span></div>
          <div class="menu-item"><span class="material-symbols-rounded text-green">check_circle</span><span>Education Qualifications (${r.educations.length} degrees)</span></div>
          <div class="menu-item"><span class="material-symbols-rounded text-green">check_circle</span><span>Skills & Proficiencies (${r.skills.length} skills)</span></div>
          <div class="menu-item"><span class="material-symbols-rounded text-green">check_circle</span><span>Featured Projects (${(r.projects || []).length} projects)</span></div>
          <div class="menu-item"><span class="material-symbols-rounded text-green">check_circle</span><span>Certifications & Credentials</span></div>
        </div>
        <button class="btn btn-primary btn-block mt-3" id="btn-finish-review">Review Resume in Live Preview</button>
      `;
      document.getElementById('btn-finish-review').onclick = () => {
        renderCanvas();
        navigateTo('screen-preview');
      };
      break;

    default:
      viewport.innerHTML = `
        <div class="card p-4 text-center">
          <span class="material-symbols-rounded text-primary" style="font-size:44px">check_circle</span>
          <h3 class="mt-2">${BUILDER_STEPS[state.builderStep]}</h3>
          <p class="text-muted mt-1">Section details configured and saved automatically.</p>
        </div>
      `;
  }
}

function triggerAutosave() {
  const statusEl = document.getElementById('builder-save-status');
  if (statusEl) statusEl.innerHTML = `<span class="material-symbols-rounded check-mini">sync</span> Saving...`;
  setTimeout(() => {
    if (statusEl) statusEl.innerHTML = `<span class="material-symbols-rounded check-mini">check_circle</span> Saved just now`;
  }, 600);
}

function setupBuilder() {
  document.getElementById('btn-builder-prev').onclick = () => {
    if (state.builderStep > 0) {
      state.builderStep--;
      renderBuilderPills();
      renderBuilderCurrentStep();
    }
  };

  document.getElementById('btn-builder-next').onclick = () => {
    if (state.builderStep < BUILDER_STEPS.length - 1) {
      state.builderStep++;
      renderBuilderPills();
      renderBuilderCurrentStep();
    } else {
      renderCanvas();
      navigateTo('screen-preview');
    }
  };

  document.getElementById('btn-builder-back').onclick = () => {
    navigateTo('screen-main-shell');
    switchTab(0);
  };

  document.getElementById('btn-builder-preview').onclick = () => {
    renderCanvas();
    navigateTo('screen-preview');
  };

  document.getElementById('btn-open-ai-sparkle').onclick = () => {
    openBottomSheet('sheet-ai');
  };
}

// 7. Live Preview & Canvas
function setupPreview() {
  document.getElementById('btn-zoom-in').onclick = () => {
    state.zoomScale = Math.min(state.zoomScale + 0.15, 2.0);
    applyZoom();
  };
  document.getElementById('btn-zoom-out').onclick = () => {
    state.zoomScale = Math.max(state.zoomScale - 0.15, 0.6);
    applyZoom();
  };
  document.getElementById('btn-zoom-reset').onclick = () => {
    state.zoomScale = 1.0;
    applyZoom();
  };

  // Floating ATS Score Pill
  const floatingAts = document.getElementById('preview-floating-ats');
  if (floatingAts) {
    floatingAts.onclick = () => {
      renderAtsChecker();
      navigateTo('screen-ats');
    };
  }

  // Fast Layout Switcher
  const btn1Col = document.getElementById('btn-fast-1col');
  const btn2Col = document.getElementById('btn-fast-2col');
  if (btn1Col && btn2Col) {
    btn1Col.onclick = () => {
      state.activeResume.customization.layout = 'oneColumn';
      btn1Col.classList.add('active');
      btn2Col.classList.remove('active');
      renderCanvas();
      showToast('Switched to Single-Column');
    };
    btn2Col.onclick = () => {
      state.activeResume.customization.layout = 'twoColumn';
      btn2Col.classList.add('active');
      btn1Col.classList.remove('active');
      renderCanvas();
      showToast('Switched to Two-Column');
    };
  }

  // Fast Palette Dots
  renderFastPaletteDots();

  document.getElementById('btn-toolbar-edit').onclick = () => {
    openResumeBuilder(state.activeResume);
  };
  document.getElementById('btn-toolbar-template').onclick = () => {
    renderTemplatesGrid();
    switchTab(2);
  };
  document.getElementById('btn-toolbar-style').onclick = () => {
    renderCustomizationSheet();
    openBottomSheet('sheet-customization');
  };
  document.getElementById('btn-toolbar-ats').onclick = () => {
    renderAtsChecker();
    navigateTo('screen-ats');
  };
  document.getElementById('btn-toolbar-export').onclick = () => {
    navigateTo('screen-export');
  };

  document.getElementById('btn-preview-ats').onclick = () => {
    renderAtsChecker();
    navigateTo('screen-ats');
  };
  document.getElementById('btn-preview-share').onclick = () => {
    openBottomSheet('sheet-share-success');
  };
  document.getElementById('btn-preview-export').onclick = () => {
    navigateTo('screen-export');
  };
}

function renderFastPaletteDots() {
  const container = document.getElementById('fast-palette-dots');
  if (!container) return;
  container.innerHTML = '';
  
  const colors = ['#2563EB', '#1E3A8A', '#18181B', '#475569', '#059669', '#991B1B'];
  colors.forEach(hex => {
    const dot = document.createElement('div');
    dot.className = `fast-dot ${state.activeResume.customization.colorHex.toLowerCase() === hex.toLowerCase() ? 'active' : ''}`;
    dot.style.background = hex;
    dot.onclick = () => {
      state.activeResume.customization.colorHex = hex;
      document.querySelectorAll('#fast-palette-dots .fast-dot').forEach(d => d.classList.remove('active'));
      dot.classList.add('active');
      renderCanvas();
    };
    container.appendChild(dot);
  });
}

function applyZoom() {
  const paper = document.getElementById('rendered-resume-paper');
  paper.style.transform = `scale(${state.zoomScale})`;
  document.getElementById('zoom-level-text').textContent = `${Math.round(state.zoomScale * 100)}%`;
}

function renderCanvas() {
  const r = state.activeResume;
  const paper = document.getElementById('rendered-resume-paper');
  const primaryColor = r.customization.colorHex || '#2563EB';
  const isTwoCol = r.customization.layout === 'twoColumn';

  let html = '';
  const projSection = (r.projects && r.projects.length > 0) ? `
    <h5 style="color:${primaryColor}; font-size: 10px; letter-spacing: 0.5px; margin-top: 10px; border-bottom: 1px solid ${primaryColor}; padding-bottom: 2px">PROJECTS</h5>
    ${r.projects.map(p => `
      <div style="margin-top: 5px">
        <strong style="font-size: 9.5px">${p.projectName}</strong> — <span style="font-size: 8.5px; color:#64748B">${p.role || 'Developer'}</span>
        <p style="font-size: 8.5px; color:#475569; margin-top: 1px">${p.description}</p>
      </div>
    `).join('')}
  ` : '';

  const certSection = (r.certifications && r.certifications.length > 0) ? `
    <h5 style="color:${primaryColor}; font-size: 9.5px; border-bottom: 1px solid ${primaryColor}; margin-top: 8px; padding-bottom: 2px">CERTIFICATIONS</h5>
    ${r.certifications.map(c => `
      <div style="margin-top: 4px">
        <strong style="font-size: 8.5px">${c.certificationName}</strong>
        <div style="font-size: 8px; color:#64748B">${c.issuingOrganization}</div>
      </div>
    `).join('')}
  ` : '';

  if (isTwoCol) {
    html = `
      <div style="border-bottom: 2px solid #E2E8F0; padding-bottom: 10px; margin-bottom: 12px">
        <h2 style="color:${primaryColor}; font-size: 20px; font-weight:800; letter-spacing: -0.3px">${r.personalInfo.fullName}</h2>
        <h4 style="color:#334155; font-size: 11.5px; font-weight: 600">${r.personalInfo.professionalTitle}</h4>
        <div style="color:#64748B; font-size: 9px; margin-top: 4px">
          ${r.personalInfo.email} • ${r.personalInfo.phone} • ${r.personalInfo.location}
        </div>
      </div>
      <div style="display:flex; gap: 14px">
        <div style="flex: 65%">
          <h5 style="color:${primaryColor}; border-bottom: 1.5px solid ${primaryColor}; font-size: 10px; padding-bottom: 2px; letter-spacing: 0.4px">SUMMARY</h5>
          <p style="font-size: 9.5px; color:#334155; margin-top: 4px; line-height: 1.4">${r.summary}</p>

          <h5 style="color:${primaryColor}; border-bottom: 1.5px solid ${primaryColor}; font-size: 10px; padding-bottom: 2px; margin-top: 10px; letter-spacing: 0.4px">WORK EXPERIENCE</h5>
          ${r.experiences.map(exp => `
            <div style="margin-top: 6px">
              <div style="display:flex; justify-content:space-between">
                <strong style="font-size:10px">${exp.jobTitle}</strong>
                <span style="font-size:8.5px; color:#64748B">${exp.startDate} - ${exp.isCurrentlyWorking ? 'Present' : exp.endDate}</span>
              </div>
              <div style="color:${primaryColor}; font-size:9.5px; font-weight:bold">${exp.company}</div>
              <p style="font-size:9px; color:#475569; margin-top:2px; line-height: 1.35">${exp.description}</p>
            </div>
          `).join('')}
          ${projSection}
        </div>
        <div style="flex: 35%; background: #F8FAFC; padding: 10px; border-radius: 6px; border: 1px solid #E2E8F0">
          <h5 style="color:${primaryColor}; font-size: 9.5px; border-bottom: 1px solid ${primaryColor}; padding-bottom: 2px; letter-spacing: 0.4px">EDUCATION</h5>
          ${r.educations.map(edu => `
            <div style="margin-top: 4px">
              <strong style="font-size: 9px">${edu.degree}</strong>
              <div style="font-size: 8px; color:#64748B">${edu.institution}</div>
            </div>
          `).join('')}

          <h5 style="color:${primaryColor}; font-size: 9.5px; border-bottom: 1px solid ${primaryColor}; margin-top: 8px; padding-bottom: 2px; letter-spacing: 0.4px">SKILLS</h5>
          ${r.skills.map(s => `
            <div style="font-size: 8.5px; margin-top: 2px">• ${s.name}</div>
          `).join('')}
          ${certSection}
        </div>
      </div>
    `;
  } else {
    // Single Column Classic
    html = `
      <div style="border-bottom: 2.5px solid ${primaryColor}; padding-bottom: 8px; margin-bottom: 10px">
        <h2 style="color:${primaryColor}; font-size: 22px; font-weight:800; letter-spacing: -0.4px">${r.personalInfo.fullName}</h2>
        <h4 style="color:#334155; font-size: 12px; font-weight: 600">${r.personalInfo.professionalTitle}</h4>
        <div style="color:#64748B; font-size: 9.5px; margin-top: 4px">
          ${r.personalInfo.email} • ${r.personalInfo.phone} • ${r.personalInfo.location}
        </div>
      </div>
      <h5 style="color:${primaryColor}; font-size: 10.5px; letter-spacing: 0.5px">PROFESSIONAL SUMMARY</h5>
      <p style="font-size: 9.5px; color:#334155; margin-top: 3px; line-height: 1.4">${r.summary}</p>
      
      <h5 style="color:${primaryColor}; font-size: 10.5px; letter-spacing: 0.5px; margin-top: 10px">WORK EXPERIENCE</h5>
      ${r.experiences.map(exp => `
        <div style="margin-top: 6px">
          <div style="display:flex; justify-content:space-between">
            <strong style="font-size:10.5px">${exp.jobTitle}</strong>
            <span style="font-size:9px; color:#64748B">${exp.startDate} - ${exp.isCurrentlyWorking ? 'Present' : exp.endDate}</span>
          </div>
          <div style="color:${primaryColor}; font-size:9.5px; font-weight:bold">${exp.company}</div>
          <p style="font-size:9px; color:#334155; margin-top:2px; line-height: 1.35">${exp.description}</p>
        </div>
      `).join('')}

      <h5 style="color:${primaryColor}; font-size: 10.5px; letter-spacing: 0.5px; margin-top: 10px">EDUCATION</h5>
      ${r.educations.map(edu => `
        <div style="margin-top: 4px">
          <strong style="font-size: 9.5px">${edu.degree}</strong>, <span style="font-size:9px; color:#64748B">${edu.institution} (GPA: ${edu.gpa})</span>
        </div>
      `).join('')}

      <h5 style="color:${primaryColor}; font-size: 10.5px; letter-spacing: 0.5px; margin-top: 10px">CORE COMPETENCIES & SKILLS</h5>
      <p style="font-size: 9px; margin-top: 3px; line-height: 1.4">${r.skills.map(s => s.name).join(' • ')}</p>
      ${projSection}
      ${certSection}
    `;
  }

  paper.innerHTML = html;
  paper.style.fontFamily = r.customization.fontFamily || 'Plus Jakarta Sans';
}

// 8. Style Customization Sheet
function renderCustomizationSheet() {
  const content = document.getElementById('customization-tab-content');
  const r = state.activeResume;

  const palettes = [
    { name: 'Royal Blue', hex: '#2563EB' },
    { name: 'Executive Navy', hex: '#1E3A8A' },
    { name: 'Classic Noir', hex: '#18181B' },
    { name: 'Slate Gray', hex: '#475569' },
    { name: 'Emerald Green', hex: '#059669' },
    { name: 'Burgundy Wine', hex: '#991B1B' }
  ];

  let palHtml = `<h4 class="mb-2">Color Palettes</h4><div style="display:grid; grid-template-columns:1fr 1fr 1fr; gap:10px">`;
  palettes.forEach(p => {
    const isSel = r.customization.colorHex.toLowerCase() === p.hex.toLowerCase();
    palHtml += `
      <div class="card p-2 text-center" style="cursor:pointer; border: ${isSel ? '2px solid ' + p.hex : '1px solid var(--outline)'}" onclick="setPalette('${p.hex}')">
        <div style="width:28px; height:28px; border-radius:50%; background:${p.hex}; margin:0 auto 4px"></div>
        <small style="font-size:11px; font-weight:600">${p.name}</small>
      </div>
    `;
  });
  palHtml += `</div>`;
  content.innerHTML = palHtml;

  // Tab switcher in sheet
  document.querySelectorAll('.sheet-tab').forEach(tab => {
    tab.onclick = () => {
      document.querySelectorAll('.sheet-tab').forEach(t => t.classList.remove('active'));
      tab.classList.add('active');
      const which = tab.getAttribute('data-tab');
      if (which === 'colors') renderCustomizationSheet();
      if (which === 'layout') {
        content.innerHTML = `
          <h4>Layout Architecture</h4>
          <div class="card mt-2 p-2" style="cursor:pointer" onclick="setLayout('twoColumn')">
            <strong>Two-Column Sidebar Layout</strong>
          </div>
          <div class="card mt-2 p-2" style="cursor:pointer" onclick="setLayout('oneColumn')">
            <strong>Single Column Classic</strong>
          </div>
        `;
      }
      if (which === 'fonts') {
        content.innerHTML = `
          <h4>Typography</h4>
          <div class="card mt-2 p-2" style="cursor:pointer" onclick="setFont('Plus Jakarta Sans')"><strong>Plus Jakarta Sans (Modern)</strong></div>
          <div class="card mt-1 p-2" style="cursor:pointer" onclick="setFont('Roboto')"><strong>Roboto (Clean Standard)</strong></div>
          <div class="card mt-1 p-2" style="cursor:pointer" onclick="setFont('Inter')"><strong>Inter (Silicon Valley Tech)</strong></div>
          <div class="card mt-1 p-2" style="cursor:pointer" onclick="setFont('Playfair Display')"><strong>Playfair Display (Executive Serif)</strong></div>
        `;
      }
    };
  });
}

window.setPalette = (hex) => {
  state.activeResume.customization.colorHex = hex;
  renderCanvas();
  renderCustomizationSheet();
  showToast('Color updated');
};
window.setLayout = (layout) => {
  state.activeResume.customization.layout = layout;
  renderCanvas();
  closeBottomSheet('sheet-customization');
  showToast('Layout updated');
};
window.setFont = (font) => {
  state.activeResume.customization.fontFamily = font;
  renderCanvas();
  closeBottomSheet('sheet-customization');
  showToast('Font updated');
};

// 9. ATS Checker
function setupAtsChecker() {
  document.getElementById('btn-ats-improve-resume').onclick = () => {
    openResumeBuilder(state.activeResume);
  };
  document.getElementById('btn-ats-goto-job-match').onclick = () => {
    navigateTo('screen-job-match');
  };

  const btnAutoOpt = document.getElementById('btn-ats-auto-optimize');
  if (btnAutoOpt) {
    btnAutoOpt.onclick = () => {
      btnAutoOpt.disabled = true;
      btnAutoOpt.innerHTML = `<span class="material-symbols-rounded check-mini">sync</span> Optimizing keywords & metrics...`;

      let current = 84;
      const target = 98;
      const interval = setInterval(() => {
        current += 2;
        if (current >= target) {
          current = target;
          clearInterval(interval);
          btnAutoOpt.innerHTML = `<span class="material-symbols-rounded">check_circle</span> Optimized to 98%!`;
          btnAutoOpt.style.background = 'var(--success)';
          showToast('Resume Auto-Optimized! ATS Score: 98%');
        }
        document.getElementById('ats-hero-score').textContent = `${current}%`;
        const badge = document.getElementById('preview-ats-score-badge');
        if (badge) badge.textContent = `${current}%`;
      }, 40);

      document.getElementById('ats-hero-title').textContent = 'Recruiter Approved (98%)';
      document.getElementById('ats-hero-desc').textContent = 'Enhanced with quantifiable metrics (%, $, time saved) and high-impact action verbs.';

      // Inject strong measurable metrics into experiences
      if (state.activeResume.experiences.length > 0) {
        state.activeResume.experiences[0].description = 'Spearheaded the redesign and mobile rewrite of the flagship fintech client application, cutting memory leaks by 42% and increasing MAU by 35%.';
      }

      renderCanvas();
      renderAtsOptimizedCategories();
    };
  }
}

function renderAtsOptimizedCategories() {
  const catContainer = document.getElementById('ats-categories-container');
  if (catContainer) {
    catContainer.innerHTML = `
      <div class="card p-2 mb-1">
        <div class="d-flex justify-between"><strong>Contact Information</strong><span>15 / 15</span></div>
        <div class="progress-track mt-1"><div class="progress-fill" style="width:100%; background:var(--success)"></div></div>
      </div>
      <div class="card p-2 mb-1">
        <div class="d-flex justify-between"><strong>Keywords & Skills Density</strong><span>25 / 25</span></div>
        <div class="progress-track mt-1"><div class="progress-fill" style="width:100%; background:var(--success)"></div></div>
      </div>
      <div class="card p-2 mb-1">
        <div class="d-flex justify-between"><strong>Work Experience & Metrics</strong><span>24 / 25</span></div>
        <div class="progress-track mt-1"><div class="progress-fill" style="width:96%; background:var(--success)"></div></div>
      </div>
      <div class="card p-2 mb-1">
        <div class="d-flex justify-between"><strong>Formatting & Structure</strong><span>10 / 10</span></div>
        <div class="progress-track mt-1"><div class="progress-fill" style="width:100%; background:var(--success)"></div></div>
      </div>
    `;
  }
}

function renderAtsChecker() {
  const catContainer = document.getElementById('ats-categories-container');
  catContainer.innerHTML = `
    <div class="card p-2 mb-1">
      <div class="d-flex justify-between"><strong>Contact Information</strong><span>14 / 15</span></div>
      <div class="progress-track mt-1"><div class="progress-fill" style="width:93%; background:var(--success)"></div></div>
    </div>
    <div class="card p-2 mb-1">
      <div class="d-flex justify-between"><strong>Keywords & Skills Density</strong><span>22 / 25</span></div>
      <div class="progress-track mt-1"><div class="progress-fill" style="width:88%; background:var(--success)"></div></div>
    </div>
    <div class="card p-2 mb-1">
      <div class="d-flex justify-between"><strong>Work Experience & Metrics</strong><span>20 / 25</span></div>
      <div class="progress-track mt-1"><div class="progress-fill" style="width:80%; background:var(--success)"></div></div>
    </div>
    <div class="card p-2 mb-1">
      <div class="d-flex justify-between"><strong>Formatting & Structure</strong><span>10 / 10</span></div>
      <div class="progress-track mt-1"><div class="progress-fill" style="width:100%; background:var(--success)"></div></div>
    </div>
  `;

  const recContainer = document.getElementById('ats-recommendations-container');
  recContainer.innerHTML = `
    <div class="card p-2 mb-1 d-flex">
      <span class="material-symbols-rounded text-green mr-2">check_circle</span>
      <div style="flex:1"><strong>Clean Layout</strong><p class="text-muted" style="font-size:11.5px">Standard single-layer typography easily readable by modern scanners.</p></div>
    </div>
    <div class="card p-2 mb-1 d-flex">
      <span class="material-symbols-rounded text-amber mr-2">lightbulb</span>
      <div style="flex:1"><strong>Add Specific Metrics</strong><p class="text-muted" style="font-size:11.5px">Consider adding more numerical stats (e.g. % increased, \$ saved) to achievements.</p></div>
    </div>
  `;
}

// 10. Job Matcher
function setupJobMatcher() {
  document.getElementById('btn-paste-sample-jd').onclick = () => {
    document.getElementById('input-job-description').value = 
      "Seeking a Senior Software Engineer with strong experience in Flutter, Dart, REST APIs, CI/CD pipelines, automated testing, and agile team leadership.";
  };

  document.getElementById('btn-analyze-jd').onclick = () => {
    const text = document.getElementById('input-job-description').value.trim();
    if (!text) return;
    
    document.getElementById('job-match-results').classList.remove('hidden');
    document.getElementById('job-match-pct').textContent = '82%';
    document.getElementById('job-match-summary-text').textContent = 'Your resume aligns with 82% of required qualifications.';
    
    document.getElementById('matched-keywords-chips').innerHTML = `
      <span class="badge-pill bg-green-tint">FLUTTER</span>
      <span class="badge-pill bg-green-tint">DART</span>
      <span class="badge-pill bg-green-tint">REST APIS</span>
      <span class="badge-pill bg-green-tint">AGILE</span>
    `;
    document.getElementById('missing-keywords-chips').innerHTML = `
      <span class="badge-pill bg-amber-tint">CI/CD</span>
      <span class="badge-pill bg-amber-tint">AUTOMATED TESTING</span>
    `;
    document.getElementById('match-alignment-tips').innerHTML = `
      <p style="font-size:12.5px; margin-bottom:4px">• Incorporate CI/CD pipeline automation experience into your summary.</p>
      <p style="font-size:12.5px">• Explicitly mention unit and widget testing coverage.</p>
    `;
  };

  const btnAutoTailor = document.getElementById('btn-auto-tailor-job');
  if (btnAutoTailor) {
    btnAutoTailor.onclick = () => {
      // Injects missing keywords
      state.activeResume.skills.push({ name: 'CI/CD Pipelines', level: 'Advanced', pct: 0.85 });
      state.activeResume.skills.push({ name: 'Automated Testing', level: 'Advanced', pct: 0.85 });
      
      document.getElementById('job-match-pct').textContent = '96%';
      document.getElementById('job-match-summary-text').textContent = 'Outstanding match! 96% of job requirements satisfied.';
      document.getElementById('matched-keywords-chips').innerHTML = `
        <span class="badge-pill bg-green-tint">FLUTTER</span>
        <span class="badge-pill bg-green-tint">DART</span>
        <span class="badge-pill bg-green-tint">REST APIS</span>
        <span class="badge-pill bg-green-tint">AGILE</span>
        <span class="badge-pill bg-green-tint">CI/CD</span>
        <span class="badge-pill bg-green-tint">AUTOMATED TESTING</span>
      `;
      document.getElementById('missing-keywords-chips').innerHTML = `
        <span class="badge-pill bg-green-tint"><span class="material-symbols-rounded" style="font-size:12px">check</span> ALL MATCHED</span>
      `;
      btnAutoTailor.innerHTML = `<span class="material-symbols-rounded">check_circle</span> Resume Tailored (96% Match)!`;
      btnAutoTailor.style.background = 'var(--success)';
      renderCanvas();
      showToast('Resume tailored with target job keywords!');
    };
  }
}

// 11. AI Assistant
function setupAiAssistant() {
  document.querySelectorAll('#ai-quick-pills .chip').forEach(chip => {
    chip.onclick = () => {
      const action = chip.getAttribute('data-ai');
      document.getElementById('ai-input-text').value = `Please ${action.toLowerCase()} for my resume.`;
      triggerAiRun();
    };
  });

  document.getElementById('btn-ai-generate').onclick = triggerAiRun;

  function triggerAiRun() {
    const box = document.getElementById('ai-result-box');
    box.classList.remove('hidden');
    const out = document.getElementById('ai-output-text');
    out.value = 'Generating response...';
    setTimeout(() => {
      out.value = `Results-oriented Senior Engineer with proven success architecting scalable mobile platforms. Demonstrates expertise in Flutter, microservices, and leading high-performing agile engineering teams to accelerate time-to-market.`;
    }, 450);
  }

  document.getElementById('btn-ai-insert').onclick = () => {
    state.activeResume.summary = document.getElementById('ai-output-text').value;
    closeBottomSheet('sheet-ai');
    showToast('Inserted into resume summary!');
    renderCanvas();
  };
  document.getElementById('btn-ai-regenerate').onclick = triggerAiRun;
  document.getElementById('btn-copy-ai').onclick = () => {
    navigator.clipboard.writeText(document.getElementById('ai-output-text').value);
    showToast('Copied to clipboard!');
  };
}

// 12. Export Screen
function setupExport() {
  document.getElementById('btn-download-pdf').onclick = () => {
    showToast('Downloading PDF...');
    setTimeout(() => {
      window.print();
    }, 300);
  };
  document.getElementById('btn-share-resume-sheet').onclick = () => {
    openBottomSheet('sheet-share-success');
  };
  document.getElementById('btn-sheet-share-native').onclick = () => {
    closeBottomSheet('sheet-share-success');
    showToast('Android Share Sheet opened');
  };
  document.getElementById('btn-sheet-share-text').onclick = () => {
    closeBottomSheet('sheet-share-success');
    navigator.clipboard.writeText(`${state.activeResume.title}\n${state.activeResume.summary}`);
    showToast('Resume text copied to clipboard!');
  };
}

// 13. Templates Screen
function renderTemplatesGrid() {
  const container = document.getElementById('templates-grid-container');
  container.innerHTML = '';
  TEMPLATES.forEach(t => {
    const card = document.createElement('div');
    card.className = 'template-card';
    card.innerHTML = `
      <div class="template-thumb" style="border-top:3px solid ${t.color}">
        <div style="display:flex; justify-content:space-between">
          <div style="width:16px; height:16px; border-radius:50%; background:${t.color}"></div>
          ${t.isPro ? '<span class="badge-pro">PRO</span>' : ''}
        </div>
        <div style="width:50px; height:5px; background:${t.color}; margin-top:6px"></div>
      </div>
      <h4>${t.name}</h4>
      <span class="cat">${t.category}</span>
      <button class="btn btn-sm btn-secondary mt-1" style="width:100%" onclick="applyTemplate('${t.id}', '${t.color}')">Use Template</button>
    `;
    container.appendChild(card);
  });
}

window.applyTemplate = (id, color) => {
  state.activeResume.customization.templateId = id;
  state.activeResume.customization.colorHex = color;
  renderCanvas();
  showToast(`Switched to template!`);
  navigateTo('screen-preview');
};

// 14. Tips Screen
function renderTipsList() {
  const container = document.getElementById('tips-list-container');
  const tips = [
    { title: 'How to Write a Professional Summary', cat: 'Strategy', desc: 'Master the 3-sentence formula that catches recruiter attention in 6 seconds.' },
    { title: 'Resume Mistakes to Avoid', cat: 'Pitfalls', desc: 'The 7 most common traps that lead to automatic rejection by screening bots.' },
    { title: 'Google X-Y-Z Formula for Achievements', cat: 'Impact', desc: 'Accomplished [X] as measured by [Y], by doing [Z].' },
    { title: 'How to Optimize for ATS Parsers', cat: 'Optimization', desc: 'Demystify applicant tracking software and pass recruiter scans.' },
    { title: 'Resume Length: 1 Page vs 2 Pages', cat: 'Guidelines', desc: 'When single-page is mandatory and when a second page is helpful.' }
  ];

  container.innerHTML = '';
  tips.forEach(t => {
    const card = document.createElement('div');
    card.className = 'card mb-2 p-3';
    card.style.cursor = 'pointer';
    card.innerHTML = `
      <div class="d-flex align-center">
        <span class="material-symbols-rounded text-primary" style="font-size:24px">article</span>
        <div class="ml-2" style="flex:1">
          <span class="badge-pill bg-blue-tint">${t.cat}</span>
          <h4 class="mt-1">${t.title}</h4>
          <p class="text-muted" style="font-size:12px">${t.desc}</p>
        </div>
        <span class="material-symbols-rounded chevron">chevron_right</span>
      </div>
    `;
    card.onclick = () => {
      document.getElementById('tip-modal-title').textContent = t.title;
      document.getElementById('tip-modal-cat').textContent = t.cat;
      document.getElementById('tip-modal-content').textContent = `${t.desc}\n\nKey takeaways:\n1. Quantify your accomplishments with real numbers and business impact.\n2. Avoid buzzwords and replace with verified technical and leadership competencies.\n3. Match target keywords from the job description seamlessly into your experience bullets.`;
      openBottomSheet('sheet-tip-detail');
    };
    container.appendChild(card);
  });
}

// 15. Profile & Settings
function setupProfileAndSettings() {
  document.getElementById('btn-open-settings').onclick = () => navigateTo('screen-settings');
  document.getElementById('menu-settings').onclick = () => navigateTo('screen-settings');
  document.getElementById('menu-sub').onclick = () => navigateTo('screen-pro');
  document.getElementById('profile-upgrade-banner').onclick = () => navigateTo('screen-pro');

  document.getElementById('btn-edit-profile-name').onclick = () => {
    const name = prompt('Edit Profile Name:', state.user.name);
    if (name) {
      state.user.name = name;
      document.querySelectorAll('.user-display-name').forEach(el => el.textContent = name);
      showToast('Profile updated');
    }
  };

  document.getElementById('menu-logout').onclick = () => {
    if (confirm('Are you sure you want to log out?')) {
      navigateTo('screen-login');
      showToast('Logged out');
    }
  };

  document.getElementById('btn-upgrade-pro-confirm').onclick = () => {
    state.user.isPro = true;
    document.getElementById('badge-pro-user').classList.remove('hidden');
    document.getElementById('profile-upgrade-banner').classList.add('hidden');
    showToast('Welcome to ResumeCraft Pro!');
    navigateTo('screen-main-shell');
    switchTab(4);
  };

  document.getElementById('btn-bill-monthly').onclick = (e) => {
    document.querySelectorAll('.bill-btn').forEach(b => b.classList.remove('active'));
    e.target.classList.add('active');
    document.getElementById('price-display').innerHTML = '$6.99 <span>/ month</span>';
    document.getElementById('price-sub-display').textContent = 'Billed monthly. Cancel anytime.';
  };
  document.getElementById('btn-bill-annual').onclick = (e) => {
    document.querySelectorAll('.bill-btn').forEach(b => b.classList.remove('active'));
    e.target.classList.add('active');
    document.getElementById('price-display').innerHTML = '$3.33 <span>/ month</span>';
    document.getElementById('price-sub-display').textContent = 'Billed annually at $39.99/yr. Cancel anytime.';
  };

  document.getElementById('btn-backup-data').onclick = () => {
    const json = JSON.stringify(state.savedResumes, null, 2);
    navigator.clipboard.writeText(json);
    showToast('Backup JSON copied to clipboard!');
  };
  document.getElementById('btn-delete-all-resumes').onclick = () => {
    if (confirm('Delete all saved resumes?')) {
      state.savedResumes = [];
      showToast('All resumes deleted');
      renderResumesList();
    }
  };
}

// 16. My Resumes Screen
function renderResumesList() {
  const container = document.getElementById('resumes-container');
  container.innerHTML = '';
  if (state.savedResumes.length === 0) {
    container.innerHTML = `
      <div class="card p-4 text-center mt-3">
        <span class="material-symbols-rounded text-primary" style="font-size:44px">folder_open</span>
        <h3 class="mt-2">You haven't created a resume yet</h3>
        <p class="text-muted mt-1" style="font-size:13px">Create your first professional CV with AI suggestions.</p>
        <button class="btn btn-primary mt-2" onclick="document.getElementById('btn-create-resume').click()">Create Your First Resume</button>
      </div>
    `;
    return;
  }

  state.savedResumes.forEach((r, idx) => {
    const card = document.createElement('div');
    card.className = 'card mb-2 p-3';
    card.innerHTML = `
      <div class="d-flex justify-between align-center">
        <div class="d-flex align-center">
          <div class="doc-icon-box"><span class="material-symbols-rounded">description</span></div>
          <div class="ml-2">
            <strong>${r.title}</strong>
            <p class="text-muted" style="font-size:12px">${r.resumeType} • Edited today</p>
          </div>
        </div>
      </div>
      <div class="progress-track mt-2"><div class="progress-fill" style="width:85%"></div></div>
      <div class="d-flex justify-between align-center mt-2">
        <button class="btn btn-sm btn-outline" onclick="openResumeBuilder(state.savedResumes[${idx}])"><span class="material-symbols-rounded">edit</span> Edit</button>
        <button class="btn btn-sm btn-secondary" onclick="state.activeResume = state.savedResumes[${idx}]; renderCanvas(); navigateTo('screen-preview')"><span class="material-symbols-rounded">visibility</span> Preview</button>
        <button class="btn btn-sm btn-outline text-danger" onclick="deleteResume(${idx})"><span class="material-symbols-rounded">delete</span></button>
      </div>
    `;
    container.appendChild(card);
  });
}

window.deleteResume = (idx) => {
  if (confirm('Delete this resume?')) {
    state.savedResumes.splice(idx, 1);
    renderResumesList();
    showToast('Resume deleted');
  }
};

// Sheet Controls
function openBottomSheet(sheetId) {
  const sheet = document.getElementById(sheetId);
  if (sheet) sheet.classList.add('open');
}
function closeBottomSheet(sheetId) {
  const sheet = document.getElementById(sheetId);
  if (sheet) sheet.classList.remove('open');
}
document.querySelectorAll('.btn-close-sheet, .sheet-backdrop').forEach(el => {
  el.addEventListener('click', () => {
    document.querySelectorAll('.bottom-sheet').forEach(s => s.classList.remove('open'));
  });
});

// Splash Screen Animation Controller
let splashTimer = null;
let splashInterval = null;

function playSplashScreen(onComplete) {
  if (splashTimer) clearTimeout(splashTimer);
  if (splashInterval) clearInterval(splashInterval);

  navigateTo('screen-splash', false);

  const progressBar = document.getElementById('splash-progress-bar');
  const percentEl = document.getElementById('splash-percentage');
  const statusEl = document.getElementById('splash-status-text');
  const splashScreen = document.getElementById('screen-splash');

  if (progressBar) progressBar.style.width = '0%';
  if (percentEl) percentEl.textContent = '0%';
  if (statusEl) statusEl.textContent = 'Loading recruiter templates...';

  // Force reflow on hero elements to retrigger CSS animations cleanly
  const logoCard = document.querySelector('.splash-logo-card');
  const badge = document.querySelector('.splash-check-badge');
  const textGroup = document.querySelector('.splash-text-group');
  const loaderSec = document.querySelector('.splash-loader-section');
  [logoCard, badge, textGroup, loaderSec].forEach(el => {
    if (el) {
      el.style.animation = 'none';
      void el.offsetHeight;
      el.style.animation = '';
    }
  });

  const durationMs = 2800;
  const intervalMs = 30;
  const steps = durationMs / intervalMs;
  let currentStep = 0;

  const finishSplash = () => {
    if (splashInterval) clearInterval(splashInterval);
    if (splashTimer) clearTimeout(splashTimer);
    if (progressBar) progressBar.style.width = '100%';
    if (percentEl) percentEl.textContent = '100%';
    if (statusEl) statusEl.textContent = 'Ready!';
    
    splashTimer = setTimeout(() => {
      if (typeof onComplete === 'function') {
        onComplete();
      } else {
        navigateTo('screen-onboarding');
      }
    }, 400);
  };

  // Allow clicking anywhere to skip
  if (splashScreen) {
    splashScreen.onclick = () => {
      finishSplash();
    };
  }

  splashInterval = setInterval(() => {
    currentStep++;
    const progress = Math.min(1, currentStep / steps);
    const pct = Math.round(progress * 100);

    if (progressBar) progressBar.style.width = `${pct}%`;
    if (percentEl) percentEl.textContent = `${pct}%`;

    if (statusEl) {
      if (progress < 0.30) {
        statusEl.textContent = 'Loading recruiter templates...';
      } else if (progress < 0.65) {
        statusEl.textContent = 'Calibrating ATS scanner...';
      } else if (progress < 0.90) {
        statusEl.textContent = 'Preparing workspace...';
      } else {
        statusEl.textContent = 'Ready!';
      }
    }

    if (progress >= 1) {
      clearInterval(splashInterval);
      finishSplash();
    }
  }, intervalMs);
}

// Simulator & Fullscreen Controls
function toggleFullScreen() {
  const isFs = document.body.classList.toggle('is-fullscreen');
  const btnFs = document.getElementById('btn-fullscreen');

  if (isFs) {
    if (btnFs) {
      btnFs.innerHTML = '<span class="material-symbols-rounded">fullscreen_exit</span><span>Exit Full</span>';
    }
    if (!document.fullscreenElement && document.documentElement.requestFullscreen) {
      document.documentElement.requestFullscreen().catch(() => {});
    }
  } else {
    if (btnFs) {
      btnFs.innerHTML = '<span class="material-symbols-rounded">fullscreen</span><span>Full Screen</span>';
    }
    if (document.fullscreenElement && document.exitFullscreen) {
      document.exitFullscreen().catch(() => {});
    }
  }
}

function exitFullScreen() {
  document.body.classList.remove('is-fullscreen');
  const btnFs = document.getElementById('btn-fullscreen');
  if (btnFs) {
    btnFs.innerHTML = '<span class="material-symbols-rounded">fullscreen</span><span>Full Screen</span>';
  }
  if (document.fullscreenElement && document.exitFullscreen) {
    document.exitFullscreen().catch(() => {});
  }
}

function setupSimulatorControls() {
  const replayBtn = document.getElementById('btn-replay-splash');
  if (replayBtn) {
    replayBtn.onclick = () => {
      playSplashScreen();
    };
  }

  const btnFs = document.getElementById('btn-fullscreen');
  if (btnFs) {
    btnFs.onclick = toggleFullScreen;
  }

  const btnToggleFrame = document.getElementById('btn-toggle-frame');
  if (btnToggleFrame) {
    btnToggleFrame.onclick = () => {
      const frame = document.getElementById('phone-frame');
      frame.classList.toggle('has-chassis');
      const hasChassis = frame.classList.contains('has-chassis');
      btnToggleFrame.innerHTML = hasChassis
        ? '<span class="material-symbols-rounded">smartphone</span><span>Framed</span>'
        : '<span class="material-symbols-rounded">stay_current_portrait</span><span>Chassis</span>';
    };
  }

  document.getElementById('btn-toggle-theme').onclick = () => {
    document.body.classList.toggle('theme-dark');
  };

  document.getElementById('btn-restart-app').onclick = () => {
    playSplashScreen();
  };

  // Keyboard shortcut: Press 'F' to toggle fullscreen, 'Escape' to exit
  window.addEventListener('keydown', (e) => {
    if (e.key === 'f' || e.key === 'F') {
      if (['INPUT', 'TEXTAREA'].includes(document.activeElement?.tagName)) return;
      toggleFullScreen();
    } else if (e.key === 'Escape') {
      exitFullScreen();
    }
  });

  // Synchronize state with native browser fullscreenchange
  document.addEventListener('fullscreenchange', () => {
    if (!document.fullscreenElement && document.body.classList.contains('is-fullscreen')) {
      exitFullScreen();
    }
  });
}
