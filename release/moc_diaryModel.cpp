/****************************************************************************
** Meta object code from reading C++ file 'diaryModel.h'
**
** Created by: The Qt Meta Object Compiler version 68 (Qt 6.6.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../diaryModel.h"
#include <QtCore/qmetatype.h>

#if __has_include(<QtCore/qtmochelpers.h>)
#include <QtCore/qtmochelpers.h>
#else
QT_BEGIN_MOC_NAMESPACE
#endif


#include <memory>

#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'diaryModel.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 68
#error "This file was generated using the moc from 6.6.1. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {

#ifdef QT_MOC_HAS_STRINGDATA
struct qt_meta_stringdata_CLASSDiaryModelENDCLASS_t {};
static constexpr auto qt_meta_stringdata_CLASSDiaryModelENDCLASS = QtMocHelpers::stringData(
    "DiaryModel",
    "completedCountChanged",
    "",
    "activeCountChanged",
    "sortRecords",
    "sortFactor",
    "addItem",
    "title",
    "date",
    "time",
    "reminder",
    "repeatMode",
    "category",
    "notes",
    "completed",
    "updateItem",
    "id",
    "removeItem",
    "getByCategoryUniqueList",
    "updateCounts",
    "clearCompletedRecords",
    "offReminders",
    "isRecordExists",
    "haveRecordsAtDate",
    "columnIndex",
    "columnName",
    "completedCount",
    "activeCount",
    "proxyModel",
    "QSortFilterProxyModel*"
);
#else  // !QT_MOC_HAS_STRING_DATA
struct qt_meta_stringdata_CLASSDiaryModelENDCLASS_t {
    uint offsetsAndSizes[60];
    char stringdata0[11];
    char stringdata1[22];
    char stringdata2[1];
    char stringdata3[19];
    char stringdata4[12];
    char stringdata5[11];
    char stringdata6[8];
    char stringdata7[6];
    char stringdata8[5];
    char stringdata9[5];
    char stringdata10[9];
    char stringdata11[11];
    char stringdata12[9];
    char stringdata13[6];
    char stringdata14[10];
    char stringdata15[11];
    char stringdata16[3];
    char stringdata17[11];
    char stringdata18[24];
    char stringdata19[13];
    char stringdata20[22];
    char stringdata21[13];
    char stringdata22[15];
    char stringdata23[18];
    char stringdata24[12];
    char stringdata25[11];
    char stringdata26[15];
    char stringdata27[12];
    char stringdata28[11];
    char stringdata29[23];
};
#define QT_MOC_LITERAL(ofs, len) \
    uint(sizeof(qt_meta_stringdata_CLASSDiaryModelENDCLASS_t::offsetsAndSizes) + ofs), len 
Q_CONSTINIT static const qt_meta_stringdata_CLASSDiaryModelENDCLASS_t qt_meta_stringdata_CLASSDiaryModelENDCLASS = {
    {
        QT_MOC_LITERAL(0, 10),  // "DiaryModel"
        QT_MOC_LITERAL(11, 21),  // "completedCountChanged"
        QT_MOC_LITERAL(33, 0),  // ""
        QT_MOC_LITERAL(34, 18),  // "activeCountChanged"
        QT_MOC_LITERAL(53, 11),  // "sortRecords"
        QT_MOC_LITERAL(65, 10),  // "sortFactor"
        QT_MOC_LITERAL(76, 7),  // "addItem"
        QT_MOC_LITERAL(84, 5),  // "title"
        QT_MOC_LITERAL(90, 4),  // "date"
        QT_MOC_LITERAL(95, 4),  // "time"
        QT_MOC_LITERAL(100, 8),  // "reminder"
        QT_MOC_LITERAL(109, 10),  // "repeatMode"
        QT_MOC_LITERAL(120, 8),  // "category"
        QT_MOC_LITERAL(129, 5),  // "notes"
        QT_MOC_LITERAL(135, 9),  // "completed"
        QT_MOC_LITERAL(145, 10),  // "updateItem"
        QT_MOC_LITERAL(156, 2),  // "id"
        QT_MOC_LITERAL(159, 10),  // "removeItem"
        QT_MOC_LITERAL(170, 23),  // "getByCategoryUniqueList"
        QT_MOC_LITERAL(194, 12),  // "updateCounts"
        QT_MOC_LITERAL(207, 21),  // "clearCompletedRecords"
        QT_MOC_LITERAL(229, 12),  // "offReminders"
        QT_MOC_LITERAL(242, 14),  // "isRecordExists"
        QT_MOC_LITERAL(257, 17),  // "haveRecordsAtDate"
        QT_MOC_LITERAL(275, 11),  // "columnIndex"
        QT_MOC_LITERAL(287, 10),  // "columnName"
        QT_MOC_LITERAL(298, 14),  // "completedCount"
        QT_MOC_LITERAL(313, 11),  // "activeCount"
        QT_MOC_LITERAL(325, 10),  // "proxyModel"
        QT_MOC_LITERAL(336, 22)   // "QSortFilterProxyModel*"
    },
    "DiaryModel",
    "completedCountChanged",
    "",
    "activeCountChanged",
    "sortRecords",
    "sortFactor",
    "addItem",
    "title",
    "date",
    "time",
    "reminder",
    "repeatMode",
    "category",
    "notes",
    "completed",
    "updateItem",
    "id",
    "removeItem",
    "getByCategoryUniqueList",
    "updateCounts",
    "clearCompletedRecords",
    "offReminders",
    "isRecordExists",
    "haveRecordsAtDate",
    "columnIndex",
    "columnName",
    "completedCount",
    "activeCount",
    "proxyModel",
    "QSortFilterProxyModel*"
};
#undef QT_MOC_LITERAL
#endif // !QT_MOC_HAS_STRING_DATA
} // unnamed namespace

Q_CONSTINIT static const uint qt_meta_data_CLASSDiaryModelENDCLASS[] = {

 // content:
      12,       // revision
       0,       // classname
       0,    0, // classinfo
      16,   14, // methods
       2,  170, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       2,       // signalCount

 // signals: name, argc, parameters, tag, flags, initial metatype offsets
       1,    0,  110,    2, 0x06,    3 /* Public */,
       3,    0,  111,    2, 0x06,    4 /* Public */,

 // methods: name, argc, parameters, tag, flags, initial metatype offsets
       4,    1,  112,    2, 0x02,    5 /* Public */,
       6,    8,  115,    2, 0x02,    7 /* Public */,
      15,    9,  132,    2, 0x02,   16 /* Public */,
      17,    1,  151,    2, 0x02,   26 /* Public */,
      18,    0,  154,    2, 0x102,   28 /* Public | MethodIsConst  */,
      19,    0,  155,    2, 0x02,   29 /* Public */,
      20,    0,  156,    2, 0x02,   30 /* Public */,
      21,    0,  157,    2, 0x02,   31 /* Public */,
      22,    1,  158,    2, 0x102,   32 /* Public | MethodIsConst  */,
      23,    1,  161,    2, 0x102,   34 /* Public | MethodIsConst  */,
      24,    1,  164,    2, 0x102,   36 /* Public | MethodIsConst  */,
      26,    0,  167,    2, 0x102,   38 /* Public | MethodIsConst  */,
      27,    0,  168,    2, 0x102,   39 /* Public | MethodIsConst  */,
      28,    0,  169,    2, 0x102,   40 /* Public | MethodIsConst  */,

 // signals: parameters
    QMetaType::Void,
    QMetaType::Void,

 // methods: parameters
    QMetaType::Void, QMetaType::QString,    5,
    QMetaType::Void, QMetaType::QString, QMetaType::QDate, QMetaType::QTime, QMetaType::QString, QMetaType::QString, QMetaType::QString, QMetaType::QString, QMetaType::Bool,    7,    8,    9,   10,   11,   12,   13,   14,
    QMetaType::Void, QMetaType::QString, QMetaType::QDate, QMetaType::QTime, QMetaType::QString, QMetaType::QString, QMetaType::QString, QMetaType::QString, QMetaType::Bool, QMetaType::Int,    7,    8,    9,   10,   11,   12,   13,   14,   16,
    QMetaType::Void, QMetaType::Int,   16,
    QMetaType::QVariantList,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Bool, QMetaType::Int,   16,
    QMetaType::Bool, QMetaType::QDate,    8,
    QMetaType::Int, QMetaType::QString,   25,
    QMetaType::Int,
    QMetaType::Int,
    0x80000000 | 29,

 // properties: name, type, flags
      26, QMetaType::Int, 0x00015001, uint(0), 0,
      27, QMetaType::Int, 0x00015001, uint(1), 0,

       0        // eod
};

Q_CONSTINIT const QMetaObject DiaryModel::staticMetaObject = { {
    QMetaObject::SuperData::link<QSqlRelationalTableModel::staticMetaObject>(),
    qt_meta_stringdata_CLASSDiaryModelENDCLASS.offsetsAndSizes,
    qt_meta_data_CLASSDiaryModelENDCLASS,
    qt_static_metacall,
    nullptr,
    qt_incomplete_metaTypeArray<qt_meta_stringdata_CLASSDiaryModelENDCLASS_t,
        // property 'completedCount'
        QtPrivate::TypeAndForceComplete<int, std::true_type>,
        // property 'activeCount'
        QtPrivate::TypeAndForceComplete<int, std::true_type>,
        // Q_OBJECT / Q_GADGET
        QtPrivate::TypeAndForceComplete<DiaryModel, std::true_type>,
        // method 'completedCountChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'activeCountChanged'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'sortRecords'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QString &, std::false_type>,
        // method 'addItem'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QString &, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QDate &, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QTime &, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QString &, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QString &, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QString &, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QString &, std::false_type>,
        QtPrivate::TypeAndForceComplete<bool, std::false_type>,
        // method 'updateItem'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QString &, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QDate &, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QTime &, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QString &, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QString &, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QString &, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QString &, std::false_type>,
        QtPrivate::TypeAndForceComplete<bool, std::false_type>,
        QtPrivate::TypeAndForceComplete<int, std::false_type>,
        // method 'removeItem'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        QtPrivate::TypeAndForceComplete<int, std::false_type>,
        // method 'getByCategoryUniqueList'
        QtPrivate::TypeAndForceComplete<QVariantList, std::false_type>,
        // method 'updateCounts'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'clearCompletedRecords'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'offReminders'
        QtPrivate::TypeAndForceComplete<void, std::false_type>,
        // method 'isRecordExists'
        QtPrivate::TypeAndForceComplete<bool, std::false_type>,
        QtPrivate::TypeAndForceComplete<int, std::false_type>,
        // method 'haveRecordsAtDate'
        QtPrivate::TypeAndForceComplete<bool, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QDate &, std::false_type>,
        // method 'columnIndex'
        QtPrivate::TypeAndForceComplete<int, std::false_type>,
        QtPrivate::TypeAndForceComplete<const QString &, std::false_type>,
        // method 'completedCount'
        QtPrivate::TypeAndForceComplete<int, std::false_type>,
        // method 'activeCount'
        QtPrivate::TypeAndForceComplete<int, std::false_type>,
        // method 'proxyModel'
        QtPrivate::TypeAndForceComplete<QSortFilterProxyModel *, std::false_type>
    >,
    nullptr
} };

void DiaryModel::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<DiaryModel *>(_o);
        (void)_t;
        switch (_id) {
        case 0: _t->completedCountChanged(); break;
        case 1: _t->activeCountChanged(); break;
        case 2: _t->sortRecords((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 3: _t->addItem((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<QDate>>(_a[2])),(*reinterpret_cast< std::add_pointer_t<QTime>>(_a[3])),(*reinterpret_cast< std::add_pointer_t<QString>>(_a[4])),(*reinterpret_cast< std::add_pointer_t<QString>>(_a[5])),(*reinterpret_cast< std::add_pointer_t<QString>>(_a[6])),(*reinterpret_cast< std::add_pointer_t<QString>>(_a[7])),(*reinterpret_cast< std::add_pointer_t<bool>>(_a[8]))); break;
        case 4: _t->updateItem((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<QDate>>(_a[2])),(*reinterpret_cast< std::add_pointer_t<QTime>>(_a[3])),(*reinterpret_cast< std::add_pointer_t<QString>>(_a[4])),(*reinterpret_cast< std::add_pointer_t<QString>>(_a[5])),(*reinterpret_cast< std::add_pointer_t<QString>>(_a[6])),(*reinterpret_cast< std::add_pointer_t<QString>>(_a[7])),(*reinterpret_cast< std::add_pointer_t<bool>>(_a[8])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[9]))); break;
        case 5: _t->removeItem((*reinterpret_cast< std::add_pointer_t<int>>(_a[1]))); break;
        case 6: { QVariantList _r = _t->getByCategoryUniqueList();
            if (_a[0]) *reinterpret_cast< QVariantList*>(_a[0]) = std::move(_r); }  break;
        case 7: _t->updateCounts(); break;
        case 8: _t->clearCompletedRecords(); break;
        case 9: _t->offReminders(); break;
        case 10: { bool _r = _t->isRecordExists((*reinterpret_cast< std::add_pointer_t<int>>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 11: { bool _r = _t->haveRecordsAtDate((*reinterpret_cast< std::add_pointer_t<QDate>>(_a[1])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 12: { int _r = _t->columnIndex((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])));
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = std::move(_r); }  break;
        case 13: { int _r = _t->completedCount();
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = std::move(_r); }  break;
        case 14: { int _r = _t->activeCount();
            if (_a[0]) *reinterpret_cast< int*>(_a[0]) = std::move(_r); }  break;
        case 15: { QSortFilterProxyModel* _r = _t->proxyModel();
            if (_a[0]) *reinterpret_cast< QSortFilterProxyModel**>(_a[0]) = std::move(_r); }  break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (DiaryModel::*)();
            if (_t _q_method = &DiaryModel::completedCountChanged; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 0;
                return;
            }
        }
        {
            using _t = void (DiaryModel::*)();
            if (_t _q_method = &DiaryModel::activeCountChanged; *reinterpret_cast<_t *>(_a[1]) == _q_method) {
                *result = 1;
                return;
            }
        }
    } else if (_c == QMetaObject::ReadProperty) {
        auto *_t = static_cast<DiaryModel *>(_o);
        (void)_t;
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< int*>(_v) = _t->completedCount(); break;
        case 1: *reinterpret_cast< int*>(_v) = _t->activeCount(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
    } else if (_c == QMetaObject::ResetProperty) {
    } else if (_c == QMetaObject::BindableProperty) {
    }
}

const QMetaObject *DiaryModel::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *DiaryModel::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_CLASSDiaryModelENDCLASS.stringdata0))
        return static_cast<void*>(this);
    return QSqlRelationalTableModel::qt_metacast(_clname);
}

int DiaryModel::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QSqlRelationalTableModel::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 16)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 16;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 16)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 16;
    }else if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 2;
    }
    return _id;
}

// SIGNAL 0
void DiaryModel::completedCountChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void DiaryModel::activeCountChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}
QT_WARNING_POP
