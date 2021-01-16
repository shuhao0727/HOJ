package top.hcode.hoj.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import org.apache.ibatis.annotations.Param;
import top.hcode.hoj.pojo.entity.Announcement;
import com.baomidou.mybatisplus.extension.service.IService;
import top.hcode.hoj.pojo.vo.AnnouncementVo;

import java.util.List;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author Himit_ZH
 * @since 2020-10-23
 */
public interface AnnouncementService extends IService<Announcement> {
    IPage<AnnouncementVo> getAnnouncementList(int limit, int currentPage, Boolean notAdmin);
    IPage<AnnouncementVo> getContestAnnouncement(Long cid,Boolean notAdmin,int limit, int currentPage);
}