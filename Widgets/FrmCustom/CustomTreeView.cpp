#include "../FrmCustom/CustomTreeView.h"
#include "../../Global.h"
#include "../../Tool.h"

CCustomTreeView::CCustomTreeView(QWidget *parent) :
    QTreeView(parent)
{
    //设置上下文件菜单，自动触发void slotCustomContextMenuRequested(const QPoint &pos);  
    setContextMenuPolicy(Qt::CustomContextMenu);
    setHeaderHidden(true);//设置头隐藏  
    setExpandsOnDoubleClick(true);//设置双击展开  
    setItemsExpandable(true);//设置条目可以展开  
    setFrameStyle(QFrame::NoFrame); //去掉边框  
}

void CCustomTreeView::mousePressEvent(QMouseEvent *event)
{
    LOG_MODEL_DEBUG("Roster", "CTreeUserList::mousePressEvent");
    m_MousePressTime = QTime::currentTime();
    QTreeView::mousePressEvent(event);
}

void CCustomTreeView::mouseReleaseEvent(QMouseEvent *event)
{
    LOG_MODEL_DEBUG("Roster", "CTreeUserList::mouseReleaseEvent");
#ifdef ANDROID
    //模拟右键菜单
    QTime cur = QTime::currentTime();
    int sec = m_MousePressTime.secsTo(cur);
    LOG_MODEL_DEBUG("Roster", "m_MousePressTime:%s;currentTime:%s;sect:%d",
                    qPrintable(m_MousePressTime.toString("hh:mm:ss.zzz")),
                    qPrintable(cur.toString("hh:mm:ss.zzz")),
                    sec);
    if(sec >= 2)
    {
        emit customContextMenuRequested(QCursor::pos());
        return;
    }
#endif
    QTreeView::mouseReleaseEvent(event);
}

void CCustomTreeView::contextMenuEvent(QContextMenuEvent *event)
{
    LOG_MODEL_DEBUG("Roster", "CTreeUserList::mouseReleaseEvent");
    QTreeView::contextMenuEvent(event);
}

void CCustomTreeView::resizeEvent(QResizeEvent *event)
{
    LOG_MODEL_DEBUG("Roster", "CTreeUserList::resizeEvent:width:%d", this->geometry().width());
    Q_UNUSED(event);
    //调整列的宽度
    this->setColumnWidth(0, this->geometry().width() * 4/ 5);
    this->setColumnWidth(1, this->geometry().width() / 5);
}