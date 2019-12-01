using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using AutoMapper;
using MBDB_datalib;
using MBDB_datalib.Dto;
using MBDBapp.Models;

namespace MBDBapp.App_Start
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            // Film
            Mapper.CreateMap<Film, FilmDto>().IgnoreAllNonExisting()
                .ForMember(dto => dto.Director, f => f.MapFrom(prop => prop.tblDirector))
                .ForMember(dto => dto.CastMembers, f => f.MapFrom(prop => prop.tblCasts))
                .ForMember(dto => dto.Studio, f => f.MapFrom(prop => prop.tblStudio));

            Mapper.CreateMap<FilmDto, Film>()
                .ForMember(f => f.FilmID, opt => opt.Ignore());

            Mapper.CreateMap<CreateAndEditFilmViewModel, Film>();
            Mapper.CreateMap<Film, CreateAndEditFilmViewModel>();
            // Director
            Mapper.CreateMap<Director, DirectorDto>();
            Mapper.CreateMap<DirectorDto, Director>();

            // Cast
            Mapper.CreateMap<Cast, CastDto>()
                .ForMember(dto => dto.Actor, cs => cs.MapFrom(prop => prop.tblActor));
            Mapper.CreateMap<CastDto, Cast>();

            // Actor
            Mapper.CreateMap<Actor, ActorDto>();
            Mapper.CreateMap<ActorDto, Actor>();

            // Stduio
            Mapper.CreateMap<Studio, StudioDto>();
            Mapper.CreateMap<StudioDto, Studio>();

            // User
            Mapper.CreateMap<AspNetUser, UserDto>().ForMember(dto => dto.Films, u => u.MapFrom(prop => prop.tblFilms));
            Mapper.CreateMap<UserDto, AspNetUser>();

            // Comment
            Mapper.CreateMap<Comment, CommentDto>();
            Mapper.CreateMap<CommentDto, Comment>();

            //Role
            Mapper.CreateMap<AspNetRole, RoleDto>();
            Mapper.CreateMap<RoleDto, AspNetRole>();

        }

        
    }

    public static class ExtensionMethod
    {
        public static IMappingExpression<TSource, TDestination> IgnoreAllNonExisting<TSource, TDestination>(this IMappingExpression<TSource, TDestination> expression)
        {
            var flags = System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Instance;
            var sourceType = typeof(TSource);
            var destinationProperties = typeof(TDestination).GetProperties(flags);

            foreach (var property in destinationProperties)
            {
                if (sourceType.GetProperty(property.Name, flags) == null)
                {
                    expression.ForMember(property.Name, opt => opt.Ignore());
                }
            }
            return expression;
        }
    }
}