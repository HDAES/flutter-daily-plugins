# Flutter Daily Plugins · 100 天开源路线图

> GitHub: https://github.com/HDAES/flutter-daily-plugins  
> 目标：每天一个小而完整的 Flutter Widget、Dart 工具包或原生能力适配器，并同步生成真实测试报告与 X 原创素材包。  
> Day 001 已提交；Day 002–100 为规划选题，未经开发/测试不标记完成。

## 项目原则

- **Widget**：纯 Flutter UI 组件；**Dart**：纯 Dart 工具/控制器；**适配器**：基于 Flutter 平台 API 或现有插件封装设备/系统功能，可能需要 iOS/Android 平台权限及真机验证。
- 大多数项目控制在单一主功能、最小可运行示例、可在 1 个开发日完成的 MVP。★★★ 项目只做清晰的第一版能力，不做全功能大包。
- 每个项目都要有 `pubspec.yaml`、`lib/`、`example/`、`test/`、`README.md`、`docs/x_publish_kit.md`；原生依赖按需增加。
- 本地验证先 `flutter pub get && flutter analyze && flutter test`，原生功能应补真机/模拟器验证。未实际执行时，只写“待验证”。
- 每日 X 发布流程：真实运行 → 截图或 10–15 秒演示 → 记录问题/修复 → 发布技术总结与仓库链接；不虚构测试结果，不保证 X 原创收益。
- 开源前检查许可证、依赖版本及第三方代码使用权。不要将个人信息、密钥、服务端地址、测试账号写进代码/截图。

## 难度

- ★：简单（基础 UI/纯 Dart）
- ★★：中等（状态、异步、复杂边界）
- ★★★：较复杂（涉及并发/持久化/多平台/真实设备），必须限定 MVP。

## 路线图

### 交互与表单
| Day | 项目 / 包名 | 解决的问题 | 类型 | 难度 | 状态 |
|---|---|---|---|---|---|
| 001 | **Guarded Async Button** · `guarded_async_button` | 异步期间锁定提交按钮，防重复点击 | Widget | ★ | ✅ 已提交 |
| 002 | **OTP Cooldown Button** · `otp_cooldown_button` | 验证码按钮倒计时与重发恢复 | Widget | ★ | ⬜ 计划中 |
| 003 | **Debounced Search Field** · `debounced_search_field` | 输入防抖、清除与搜索回调 | Widget | ★ | ⬜ 计划中 |
| 004 | **Password Strength Meter** · `password_strength_meter` | 密码强度规则、提示与进度条 | Widget | ★★ | ⬜ 计划中 |
| 005 | **Masked Input Field** · `masked_input_field` | 电话/卡号等输入掩码与光标处理 | Widget | ★★ | ⬜ 计划中 |
| 006 | **Async Field Validator** · `async_field_validator` | 用户名异步校验、竞态取消 | Widget | ★★ | ⬜ 计划中 |
| 007 | **Unsaved Form Guard** · `unsaved_form_guard` | 表单未保存离开提醒 | Widget | ★★ | ⬜ 计划中 |
| 008 | **Multi-step Form Controller** · `multi_step_form_controller` | 多步骤表单切换与状态保留 | Widget | ★★ | ⬜ 计划中 |
| 009 | **Smart Paste Field** · `smart_paste_field` | 粘贴识别、校验与输入提示 | Widget | ★★ | ⬜ 计划中 |
| 010 | **Undoable Delete Action** · `undoable_delete_action` | 删除撤销窗口与超时提交 | Widget | ★★ | ⬜ 计划中 |

### 实用 UI 组件
| Day | 项目 / 包名 | 解决的问题 | 类型 | 难度 | 状态 |
|---|---|---|---|---|---|
| 011 | **Skeleton Loader** · `skeleton_loader` | 列表骨架屏与加载占位 | Widget | ★★ | ⬜ 计划中 |
| 012 | **Expandable Read More** · `expandable_read_more` | 长文本展开/收起与行数判断 | Widget | ★ | ⬜ 计划中 |
| 013 | **Animated Number Ticker** · `animated_number_ticker` | 数字变化动画与千分位 | Widget | ★ | ⬜ 计划中 |
| 014 | **Adaptive Empty State** · `adaptive_empty_state` | 空数据/错误/无网络状态页面 | Widget | ★ | ⬜ 计划中 |
| 015 | **Overflow Tooltip** · `overflow_tooltip` | 文字截断时才显示提示 | Widget | ★★ | ⬜ 计划中 |
| 016 | **Reorderable Tag Chips** · `reorderable_tag_chips` | 标签拖动排序与删除 | Widget | ★★ | ⬜ 计划中 |
| 017 | **Segmented Progress Bar** · `segmented_progress_bar` | 多阶段进度与状态说明 | Widget | ★★ | ⬜ 计划中 |
| 018 | **Before After Slider** · `before_after_slider` | 双图左右滑动对比效果 | Widget | ★★ | ⬜ 计划中 |
| 019 | **Swipe to Confirm** · `swipe_to_confirm` | 滑动确认重要操作 | Widget | ★★ | ⬜ 计划中 |
| 020 | **Adaptive Action Sheet** · `adaptive_action_sheet` | 适配平台的操作选择菜单 | Widget | ★★ | ⬜ 计划中 |

### 列表、滚动与导航
| Day | 项目 / 包名 | 解决的问题 | 类型 | 难度 | 状态 |
|---|---|---|---|---|---|
| 021 | **Infinite List Pager** · `infinite_list_pager` | 加载更多、错误重试与无数据状态 | Widget | ★★ | ⬜ 计划中 |
| 022 | **Refresh Status Header** · `refresh_status_header` | 下拉刷新状态与上次更新时间 | Widget | ★★ | ⬜ 计划中 |
| 023 | **Scroll Position Keeper** · `scroll_position_keeper` | 分页切换后恢复滚动位置 | Widget | ★★ | ⬜ 计划中 |
| 024 | **Sticky Section Header** · `sticky_section_header` | 分组列表吸顶标题 | Widget | ★★ | ⬜ 计划中 |
| 025 | **Alphabet Index List** · `alphabet_index_list` | 字母索引快速定位联系人 | Widget | ★★★ | ⬜ 计划中 |
| 026 | **Swipe Action Tile** · `swipe_action_tile` | 列表项左滑操作菜单 | Widget | ★★ | ⬜ 计划中 |
| 027 | **Grid List Switcher** · `grid_list_switcher` | 网格/列表模式切换并保持状态 | Widget | ★ | ⬜ 计划中 |
| 028 | **Page Dots Indicator** · `page_dots_indicator` | 可扩展页面指示点与动画 | Widget | ★ | ⬜ 计划中 |
| 029 | **Route Transition Kit** · `route_transition_kit` | 淡入、滑入等路由转场模板 | Widget | ★★ | ⬜ 计划中 |
| 030 | **Back Press Confirm** · `back_press_confirm` | 返回按键确认与二次退出 | Widget | ★ | ⬜ 计划中 |

### 异步与网络
| Day | 项目 / 包名 | 解决的问题 | 类型 | 难度 | 状态 |
|---|---|---|---|---|---|
| 031 | **Exponential Retry** · `exponential_retry` | 带抖动退避的异步重试 | Dart | ★★ | ⬜ 计划中 |
| 032 | **Request Coalescer** · `request_coalescer` | 并发同参数请求合并 | Dart | ★★★ | ⬜ 计划中 |
| 033 | **HTTP Timeout Policy** · `http_timeout_policy` | 统一超时与取消行为 | Dart | ★★ | ⬜ 计划中 |
| 034 | **Connectivity Status Banner** · `connectivity_status_banner` | 网络连接变化提示横幅 | 适配器 | ★★ | ⬜ 计划中 |
| 035 | **Offline Action Queue** · `offline_action_queue` | 离线操作入队及恢复后重试 | Dart | ★★★ | ⬜ 计划中 |
| 036 | **API Response Cache** · `api_response_cache` | GET 响应缓存与过期策略 | Dart | ★★ | ⬜ 计划中 |
| 037 | **Upload Progress Adapter** · `upload_progress_adapter` | 上传百分比与取消处理 | 适配器 | ★★ | ⬜ 计划中 |
| 038 | **Download Task Controller** · `download_task_controller` | 下载状态、暂停适配与进度 | 适配器 | ★★★ | ⬜ 计划中 |
| 039 | **Rate Limit Scheduler** · `rate_limit_scheduler` | 节流、令牌桶与并发上限 | Dart | ★★ | ⬜ 计划中 |
| 040 | **Circuit Breaker** · `circuit_breaker` | 连续失败熔断与恢复探测 | Dart | ★★★ | ⬜ 计划中 |

### 缓存、数据与状态
| Day | 项目 / 包名 | 解决的问题 | 类型 | 难度 | 状态 |
|---|---|---|---|---|---|
| 041 | **Memory TTL Cache** · `memory_ttl_cache` | 内存缓存过期与容量淘汰 | Dart | ★★ | ⬜ 计划中 |
| 042 | **Secure Settings Adapter** · `secure_settings_adapter` | 敏感配置读写的统一接口 | 适配器 | ★★ | ⬜ 计划中 |
| 043 | **Draft Auto Saver** · `draft_auto_saver` | 输入草稿防抖保存与恢复 | Dart | ★★ | ⬜ 计划中 |
| 044 | **Recently Viewed History** · `recently_viewed_history` | 最近浏览记录与数量上限 | Dart | ★ | ⬜ 计划中 |
| 045 | **Favorites Store** · `favorites_store` | 收藏、取消收藏与状态通知 | Dart | ★ | ⬜ 计划中 |
| 046 | **Local Search History** · `local_search_history` | 搜索历史去重与清空 | Dart | ★ | ⬜ 计划中 |
| 047 | **Typed JSON Mapper** · `typed_json_mapper` | 安全字段读取与错误定位 | Dart | ★★ | ⬜ 计划中 |
| 048 | **Data Migration Runner** · `data_migration_runner` | 本地数据版本升级与回滚提示 | Dart | ★★ | ⬜ 计划中 |
| 049 | **Offline First Repository** · `offline_first_repository` | 先读缓存、后台刷新数据 | Dart | ★★★ | ⬜ 计划中 |
| 050 | **Cache Inspector Panel** · `cache_inspector_panel` | 可视化查看缓存占用和清理 | Widget | ★★ | ⬜ 计划中 |

### 图片、文件与分享
| Day | 项目 / 包名 | 解决的问题 | 类型 | 难度 | 状态 |
|---|---|---|---|---|---|
| 051 | **Image Compression Helper** · `image_compression_helper` | 图片体积压缩与质量控制 | 适配器 | ★★★ | ⬜ 计划中 |
| 052 | **Image Dimension Guard** · `image_dimension_guard` | 尺寸、比例和大小校验 | Dart | ★ | ⬜ 计划中 |
| 053 | **Image Picker Preview** · `image_picker_preview` | 选择图片、预览与删除 | 适配器 | ★★ | ⬜ 计划中 |
| 054 | **Avatar Crop Sheet** · `avatar_crop_sheet` | 头像裁切交互与预览 | 适配器 | ★★★ | ⬜ 计划中 |
| 055 | **Smart Image Fallback** · `smart_image_fallback` | 加载失败重试与占位图 | Widget | ★ | ⬜ 计划中 |
| 056 | **File Signature Sniffer** · `file_signature_sniffer` | 文件头签名识别常见格式 | Dart | ★★ | ⬜ 计划中 |
| 057 | **File Checksum Calculator** · `file_checksum_calculator` | 流式 SHA-256 文件校验 | Dart | ★★ | ⬜ 计划中 |
| 058 | **Chunked File Reader** · `chunked_file_reader` | 大文件分块读取与进度回调 | 适配器 | ★★★ | ⬜ 计划中 |
| 059 | **File Progress Card** · `file_progress_card` | 文件任务状态与进度展示 | Widget | ★★ | ⬜ 计划中 |
| 060 | **System Share Bridge** · `system_share_bridge` | 统一封装系统分享文字和文件 | 适配器 | ★★ | ⬜ 计划中 |

### 系统能力与权限
| Day | 项目 / 包名 | 解决的问题 | 类型 | 难度 | 状态 |
|---|---|---|---|---|---|
| 061 | **Haptic Feedback Patterns** · `haptic_feedback_patterns` | 轻重触觉反馈组合 | 适配器 | ★ | ⬜ 计划中 |
| 062 | **Clipboard Copy Feedback** · `clipboard_copy_feedback` | 复制到剪贴板并显示反馈 | Widget | ★ | ⬜ 计划中 |
| 063 | **Screen Awake Scope** · `screen_awake_scope` | 指定页面防止屏幕休眠 | 适配器 | ★★ | ⬜ 计划中 |
| 064 | **Orientation Guard** · `orientation_guard` | 进入页面锁定方向，退出恢复 | 适配器 | ★★ | ⬜ 计划中 |
| 065 | **Lifecycle Event Hub** · `lifecycle_event_hub` | 前后台切换事件订阅管理 | Widget | ★★ | ⬜ 计划中 |
| 066 | **Permission Education Dialog** · `permission_education_dialog` | 请求系统权限前的用途说明 | Widget | ★★ | ⬜ 计划中 |
| 067 | **Biometric Auth Gate** · `biometric_auth_gate` | 指纹/Face ID 二次验证 | 适配器 | ★★★ | ⬜ 计划中 |
| 068 | **Deep Link Parser** · `deep_link_parser` | 深链参数解析与路由映射 | Dart | ★★ | ⬜ 计划中 |
| 069 | **Battery Status Badge** · `battery_status_badge` | 电量与充电状态展示 | 适配器 | ★★ | ⬜ 计划中 |
| 070 | **Scoped Brightness Controller** · `scoped_brightness_controller` | 页面亮度临时调整与恢复 | 适配器 | ★★ | ⬜ 计划中 |

### 日期、国际化与无障碍
| Day | 项目 / 包名 | 解决的问题 | 类型 | 难度 | 状态 |
|---|---|---|---|---|---|
| 071 | **Relative Time Label** · `relative_time_label` | 几分钟前/几小时前自动更新 | Widget | ★ | ⬜ 计划中 |
| 072 | **Time Zone Meeting Clock** · `time_zone_meeting_clock` | 跨时区时间换算与夏令时处理 | Dart | ★★ | ⬜ 计划中 |
| 073 | **Date Range Presets** · `date_range_presets` | 最近 7 天/本月等日期范围选择 | Widget | ★★ | ⬜ 计划中 |
| 074 | **Business Day Calculator** · `business_day_calculator` | 工作日加减与自定义假日 | Dart | ★★ | ⬜ 计划中 |
| 075 | **Deadline Countdown** · `deadline_countdown` | 到期倒计时与暂停恢复 | Widget | ★ | ⬜ 计划中 |
| 076 | **Money Input Formatter** · `money_input_formatter` | 金额输入精度、分组与格式 | Dart | ★★ | ⬜ 计划中 |
| 077 | **Locale Number Field** · `locale_number_field` | 按地区输入小数与千分位 | Widget | ★★ | ⬜ 计划中 |
| 078 | **RTL Layout Preview** · `rtl_layout_preview` | 一键预览从右到左布局 | Widget | ★★ | ⬜ 计划中 |
| 079 | **Accessible Tap Target** · `accessible_tap_target` | 扩大点击热区和语义标签 | Widget | ★★ | ⬜ 计划中 |
| 080 | **Text Scale Preview** · `text_scale_preview` | 动态字体缩放预览与溢出检查 | Widget | ★★ | ⬜ 计划中 |

### 动效、音视频体验
| Day | 项目 / 包名 | 解决的问题 | 类型 | 难度 | 状态 |
|---|---|---|---|---|---|
| 081 | **Voice Record Button** · `voice_record_button` | 长按录音按钮与录音状态 | 适配器 | ★★★ | ⬜ 计划中 |
| 082 | **Audio Waveform View** · `audio_waveform_view` | 基于采样幅值绘制音频波形 | Widget | ★★ | ⬜ 计划中 |
| 083 | **Audio Playback Seekbar** · `audio_playback_seekbar` | 播放进度、拖动与时间展示 | 适配器 | ★★ | ⬜ 计划中 |
| 084 | **Video Progress Scrubber** · `video_progress_scrubber` | 视频进度缩略拖动控制 | 适配器 | ★★★ | ⬜ 计划中 |
| 085 | **Typing Text Effect** · `typing_text_effect` | 打字机文字动画与光标 | Widget | ★ | ⬜ 计划中 |
| 086 | **Confetti Burst Painter** · `confetti_burst_painter` | 零依赖庆祝粒子动画 | Widget | ★★ | ⬜ 计划中 |
| 087 | **Swipe Dismiss Gallery** · `swipe_dismiss_gallery` | 图片全屏预览下滑关闭 | Widget | ★★★ | ⬜ 计划中 |
| 088 | **Animated Theme Toggle** · `animated_theme_toggle` | 浅色/深色主题平滑切换 | Widget | ★★ | ⬜ 计划中 |
| 089 | **Reaction Burst Overlay** · `reaction_burst_overlay` | 点赞表情短动画浮层 | Widget | ★★ | ⬜ 计划中 |
| 090 | **Media Lifecycle Pause** · `media_lifecycle_pause` | 应用进入后台时暂停媒体 | 适配器 | ★★ | ⬜ 计划中 |

### 开发调试与工程效率
| Day | 项目 / 包名 | 解决的问题 | 类型 | 难度 | 状态 |
|---|---|---|---|---|---|
| 091 | **App Build Info Panel** · `app_build_info_panel` | 版本、构建号和环境信息面板 | 适配器 | ★ | ⬜ 计划中 |
| 092 | **Environment Ribbon** · `environment_ribbon` | Dev/Staging/Prod 环境角标 | Widget | ★ | ⬜ 计划中 |
| 093 | **Feature Flag Registry** · `feature_flag_registry` | 功能开关与灰度条件判断 | Dart | ★★ | ⬜ 计划中 |
| 094 | **Error Capture Boundary** · `error_capture_boundary` | 子组件异常展示与上报入口 | Widget | ★★ | ⬜ 计划中 |
| 095 | **Frame Timing Monitor** · `frame_timing_monitor` | 帧耗时采样与性能可视化 | Widget | ★★ | ⬜ 计划中 |
| 096 | **Safe Network Logger** · `safe_network_logger` | 脱敏请求日志及慢请求提示 | Dart | ★★ | ⬜ 计划中 |
| 097 | **JSON Tree Inspector** · `json_tree_inspector` | 可折叠 JSON 树形查看器 | Widget | ★★ | ⬜ 计划中 |
| 098 | **In App Log Console** · `in_app_log_console` | 应用内日志筛选、复制与导出 | Widget | ★★★ | ⬜ 计划中 |
| 099 | **Golden Test Starter** · `golden_test_starter` | 组件截图基准测试示例 | Widget | ★★ | ⬜ 计划中 |
| 100 | **Widget Demo Catalog** · `widget_demo_catalog` | 搜索浏览前 99 个组件的演示入口 | Widget | ★★★ | ⬜ 计划中 |

## Day 001 代码

- [Guarded Async Button](https://github.com/HDAES/flutter-daily-plugins/tree/main/day-001-guarded-async-button)
- [Day 001 GitHub commit](https://github.com/HDAES/flutter-daily-plugins/commit/301ade2dbb533a3a60217e5884e22508d0eadc8c)

## 每日验收标准（DoD）

- [ ] 核心功能边界清楚，最小示例可展示问题与效果。
- [ ] 代码格式和静态分析结果如实记录。
- [ ] 单元/Widget 测试包含成功、失败及关键边界。
- [ ] 原生能力明确权限、平台和已测试设备。
- [ ] README 含 API、限制、安装、运行与许可证说明。
- [ ] X 素材包包含一条自然中文主帖、真实截图清单、测试报告模板。
- [ ] 只在实际测试通过后标记“Verified”；只在推送成功后标记“Published”。

## Git 提交格式

`feat(day-NNN): add <package-name>`

计划是选题，不代表全部选题已实现、适合单独发布 pub.dev 或保证 X 任何收益。发布前按当天 Flutter SDK / 平台要求调整实现。