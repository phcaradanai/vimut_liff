// import { ACL } from '@/lib/acl'

export const menus = [
  {
    id: 'home',
    to: '/xt',
    icon: 'home',
    text: 'menu.dashboard',
  },
  {
    id: 'reports',
    icon: 'summarize',
    text: 'menu.report',
    items: [
      {
        id: 'report-status',
        icon: 'summarize',
        text: 'menu.reportStatus',
        to: '/xt/reports/status',
        // acl: {
        //   'report-status': ACL.VIEW,
        // },
      },
      {
        id: 'report-noti',
        icon: 'summarize',
        text: 'menu.reportNoti',
        to: '/xt/reports/noti',
        // acl: {
        //   'report-noti': ACL.VIEW,
        // },
      },
      {
        id: 'report-summary',
        icon: 'summarize',
        text: 'menu.reportSummary',
        to: '/xt/reports/summary',
        // acl: {
        //   'report-summary': ACL.VIEW,
        // },
      },
      {
        id: 'report-monthly',
        icon: 'summarize',
        text: 'menu.reportMonthly',
        to: '/xt/reports/monthly',
        // acl: {
        //   'report-monthly': ACL.VIEW,
        // },
      },
      {
        id: 'report-covid',
        icon: 'summarize',
        text: 'menu.reportCovid',
        to: '/xt/reports/covid',
        // acl: {
        //   'report-covid': ACL.VIEW,
        // },
      },
    ],
  },
  {
    id: 'manage',
    icon: 'manage_accounts',
    text: 'menu.manage',
    items: [
      {
        id: 'xentemp',
        icon: 'face',
        text: 'menu.manageXentemp',
        to: '/xt/manage/xentemp',
        // acl: {
        //   beacons: ACL.VIEW,
        // },
      },
      {
        id: 'receptors',
        icon: 'face',
        text: 'menu.manageReceptor',
        to: '/xt/manage/receptors',
        // acl: {
        //   receptor: ACL.VIEW,
        // },
      },
      {
        id: 'temp-profile',
        icon: 'face',
        text: 'menu.manageTempProfile',
        to: '/xt/manage/tempProfiles',
        // acl: {
        //   'temp-profile': ACL.VIEW,
        // },
      },
      {
        id: 'noti-profile',
        icon: 'face',
        text: 'menu.manageNotiProfile',
        to: '/xt/manage/notiProfiles',
        // acl: {
        //   'noti-profile': ACL.VIEW,
        // },
      },
      /* {
        id: 'noti-channel',
        icon: 'face',
        text: 'menu.manageNotiChannel',
        to: '/xt/manage/noti-channel',
        // acl: {
        //   'noti-channel': ACL.VIEW,
        // },
      }, */
      {
        id: 'operator',
        icon: 'face',
        text: 'menu.manageOperator',
        to: '/xt/manage/operators',
        // acl: {
        //   'noti-channel': ACL.VIEW,
        // },
      },
    ],
  },
  {
    id: 'admin',
    icon: 'admin_panel_settings',
    text: 'menu.admin',
    items: [
      {
        id: 'projects',
        icon: 'domain',
        text: 'menu.adminProject',
        to: '/xt/admin/projects',
        // acl: {
        //   projects: ACL.VIEW,
        // },
      },
      {
        id: 'staffs',
        icon: 'manage_accounts',
        text: 'menu.adminStaff',
        to: '/xt/admin/users',
        // acl: {
        //   staffs: ACL.VIEW,
        // },
      },
      {
        id: 'roles',
        icon: 'security',
        text: 'menu.adminRole',
        to: '/xt/admin/roles',
        // acl: {
        //   roles: ACL.VIEW,
        // },
      },
      {
        id: 'audits',
        icon: 'policy',
        text: 'menu.adminAudit',
        to: '/xt/admin/audits',
        // acl: {
        //   audits: ACL.VIEW,
        // },
      },
    ],
  },
  {
    id: 'setup',
    icon: 'settings',
    text: 'menu.setup',
    items: [
      {
        id: 'modules',
        icon: 'grade',
        text: 'menu.setupModule',
        to: '/xt/setup/modules',
        // acl: {
        //   sysadmin: 1,
        //   modules: ACL.VIEW,
        // },
      },
    ],
  },
]
